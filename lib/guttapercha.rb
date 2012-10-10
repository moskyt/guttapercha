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

  def self.chart(file1, caption, options = {})
    %{
       \\begin{figure}#{options[:placement] ? "[#{options[:placement]}]" : ''}
          \\input{#{file1}}
          #{chart_caption caption, options[:label]}
        \\end{figure}
    }
  end
  
  def self.table(formats, data, options = {})
    s = []
    s << "\\begin{tabular}{#{'l' * formats.size}}"
    s << "\\toprule"
    if h = options[:headers]
      s << h.map{|w| escape(w)} * " & " + " \\\\"
      s << "\\midrule"
    end
    data.each do |row|
      s << (0...formats.size).map{|i| escape(formats[i] % row[i])} * " & " + " \\\\"
    end
    s << "\\bottomrule"
    s << "\\end{tabular}"
    s * "\n"
  end
  
  def self.chart_caption(caption, label)    
    "\\caption{#{label ? "\\label{#{label}} " : ""}#{caption}}"
  end

end