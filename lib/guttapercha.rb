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
          \\caption{#{caption}}
        \\end{figure}
    }
  end

  def self.chart(file1, caption, options = {})
    %{
       \\begin{figure}#{options[:placement] ? "[#{options[:placement]}]" : ''}
          \\input{#{file1}}
          \\caption{#{caption}}
        \\end{figure}
    }
  end

end