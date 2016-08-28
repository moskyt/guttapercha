require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/pride'

require_relative '../lib/guttapercha'

class TestBasic < MiniTest::Test
  
  def test_erb
    fn_erb = File.expand_path("template.tex.erb", File.dirname(__FILE__))
    fn_tex = File.expand_path("test_template.tex", File.dirname(__FILE__))
    fn_pdf = File.expand_path("test_template.pdf", File.dirname(__FILE__))
    `rm -f #{fn_tex}`
    `rm -f #{fn_pdf}`
    LaTeX::template(fn_erb, fn_tex, {array: [1,2,3]})
    assert File.exist?(fn_tex)
    assert File.exist?(fn_pdf)
    assert File.read(fn_tex).include?("3")
  end

  def test_escape
    assert_equal "hop\\_skok", LaTeX::escape("hop_skok")
    assert_equal "hop\\#skok", LaTeX::escape("hop#skok")
    assert_equal "$alfa_beta$\\_gama", LaTeX::escape("$alfa_beta$_gama")
  end
  
  def test_chart_caption
    assert_equal "\\caption{nadpis}", LaTeX::chart_caption('nadpis')
    assert_equal "\\caption{\\label{odkaz} nadpis}", LaTeX::chart_caption('nadpis', 'odkaz')
  end
  
  def test_just_running_charts
    LaTeX::chart("file1.png", "Chart caption")
    LaTeX::two_figures("file1.png", "file2.png", "Chart caption")
    LaTeX::two_charts("file1.png", "file2.png", "Chart caption")
  end
  
  def test_just_running_table
    t = LaTeX::table(%w{%s %.1f}, [['ahoj', 2.55], ['pisnicky', 3]])
    assert !t.include?("midrule")
    t = LaTeX::table(%w{%s %.1f}, [['ahoj', 2.55], ['pisnicky', 3]], headers: %w{word number})
    assert t.include?("midrule")
  end

  def test_doc_with_data
    fn = File.expand_path("test_doc_with_data.tex", File.dirname(__FILE__))
    `rm -f #{fn}`
    LaTeX::document(fn, {}, "hello")
    assert File.exist?(fn)
    assert File.read(fn).include?("hello")
  end  
  
  def test_doc_with_block
    fn = File.expand_path("test_doc_with_block.tex", File.dirname(__FILE__))
    `rm -f #{fn}`
    LaTeX::document(fn, {}){|f| f.puts "world"}
    assert File.exist?(fn)
    assert File.read(fn).include?("world")
  end  

  def test_doc_with_both
    fn = File.expand_path("test_doc_with_both.tex", File.dirname(__FILE__))
    assert_raises ArgumentError do
      LaTeX::document(fn, {}, "hello"){|f| f.puts "world"}
    end
  end  
  
end