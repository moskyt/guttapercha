module LaTeX

  def self.escape(s)
    return "" unless s
    s.gsub("_", "\\_").gsub("#", "\\#")
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
    cols = options[:columns]
    cols = cols * '' if Array === cols
    cols ||= 'l' * formats.size
    s << "\\begin{tabular}{#{cols}}"
    s << "\\toprule"
    if h = options[:headers]
      s << h.map{|w| options[:escape_headers] ? escape(w) : w} * " & " + " \\\\"
      s << "\\midrule"
    end
    data.each do |row|
      s << ((formats * " & ") % row) + " \\\\"
#      s << (0...formats.size).map{|i| escape(formats[i] % row[i])} * " & " + " \\\\"
    end
    s << "\\bottomrule"
    s << "\\end{tabular}"
    s * "\n"
  end
  
  def self.chart_caption(caption, label)    
    "\\caption{#{label ? "\\label{#{label}} " : ""}#{caption}}"
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
      if data
        f.puts data
      elsif block_given?
        yield(f)
      end
      f.puts "\\end{document}"
    end
    if options[:build]
      Dir.chdir(File.dirname filename) do
        `pdflatex -halt-on-error #{filename}`
        `pdflatex -halt-on-error #{filename}`
      end
    end
  end

end