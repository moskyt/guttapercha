require 'erb'
require 'pathname'

class LocalBinding
  def initialize(locals)
    @locals = locals.dup
  end
  def method_missing(x, *args)
    if args.empty? 
      if @locals.has_key?(x)
        @locals[x]
      else
        raise NoMethodError, "Unknown local variable #{x} in the template -- defined locals are #{@locals.keys.inspect}"
      end
    else
      super
    end 
  end
  def get_binding
    return binding()
  end
end  
  

module LaTeX

  def self.erb(template, filename, locals)
    erb = ERB.new(File.read(template))
    File.write(filename, erb.result(LocalBinding.new(locals.merge({_filename: filename, _template: template})).get_binding))
  end


  def self.escape(s)
    return "" unless s
    s.gsub("_", "\\_").gsub("#", "\\#").gsub("%", "\\%").gsub(/\$[^\$]+\$/){|x| x.gsub("\\_","_")}
  end

  def self.two_charts(file1, file2, caption, options = {})
    %{
       \\begin{figure}#{options[:placement] ? "[#{options[:placement]}]" : ''}
          \\begin{minipage}[!t]{0.49\\textwidth}
            \\input{#{file1}}
          \\end{minipage}
          \\begin{minipage}[!t]{0.49\\textwidth}
            \\input{#{file2}}
          \\end{minipage}
          #{chart_caption caption, options[:label]}
        \\end{figure}
    }
  end

  def self.two_figures(file1, file2, caption, options = {})
    %{
       \\begin{figure}#{options[:placement] ? "[#{options[:placement]}]" : ''}
          \\begin{minipage}[!t]{0.49\\textwidth}
            \\includegraphics[width=\\textwidth]{#{file1}}
          \\end{minipage}
          \\begin{minipage}[!t]{0.49\\textwidth}
            \\includegraphics[width=\\textwidth]{#{file2}}
          \\end{minipage}
          #{chart_caption caption, options[:label]}
        \\end{figure}
    }
  end
  
  def self.chart(file1, caption, options = {})
    %{
       \\begin{figure}#{options[:placement] ? "[#{options[:placement]}]" : ''}
          \\input{#{file1}}
          #{chart_caption caption, options[:label]}
        \\end{figure}
    }
  end
  
  def self.table(formats, data, options = {})
    options = {:escape_headers => true}.merge(options)
    s = []
    cols = options[:columns] || ['l'] * formats.size
    if options[:stretch]
#      s << "\\begin{tabular*}{\\columnwidth}{@{\\extracolsep{\\stretch{1}}}*{#{cols.size}}{r}@{}}"
      s << "\\begin{tabular*}{\\columnwidth}{#{cols.map{|x| "@{\\extracolsep{\\stretch{1}}}*{1}{#{x}}@{}"}*''}}"
    else
      s << "\\begin{tabular}{#{cols*''}}"
    end
    s << "\\toprule"
    if h = options[:headers]
      s << h.map{|w| options[:escape_headers] ? escape(w) : w} * " & " + " \\\\"
      s << "\\midrule"
    end
    data.each do |row|
      s << escape((formats * " & ") % row) + " \\\\"
      #s << (0...formats.size).map{|i| escape(formats[i] % row[i])} * " & " + " \\\\"
    end
    s << "\\bottomrule"
    if options[:stretch]
      s << "\\end{tabular*}"
    else
      s << "\\end{tabular}"
    end
    s * "\n"
  end
  
  def self.chart_caption(caption, label = nil)    
    "\\caption{#{label ? "\\label{#{label}} " : ""}#{caption}}"
  end
  
  def self.template(template, filename, locals = {})
    erb(template, filename, locals)
    build(filename)
  end
  
  def self.build(filename)
    Dir.chdir(File.dirname filename) do
      `pdflatex -interaction=batchmode -halt-on-error #{filename}`
      `pdflatex -interaction=batchmode -halt-on-error #{filename}`
    end
  end
  
  def self.document(filename, options = {}, data = nil)
    File.open(filename, 'w') do |f|
      f.puts %{
      \\documentclass[a4paper,11pt]{article}

      \\usepackage[utf8]{inputenc}
      \\usepackage[rgb]{xcolor}
      \\usepackage{placeins,array,lscape}
      \\usepackage{color,tikz,pgfplots,float}
      \\usepackage{graphicx,booktabs,hyperref}
      \\usepackage[margin=1.5cm]{geometry}

      \\usetikzlibrary{patterns}
      \\pagestyle{empty}

      \\begin{document}  
      }
      if data and block_given?
        raise ArgumentError, "Cannot supply both data and block"
      elsif data
        f.puts data
      elsif block_given?
        yield(f)
      end
      f.puts "\\end{document}"
    end
    build(filename) if options[:build]
  end

end