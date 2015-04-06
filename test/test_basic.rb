require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/pride'

require_relative '../lib/guttapercha'

class TestBasic < MiniTest::Test

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
    LaTeX::table(%w{%s %.1f}, [['ahoj', 2.55], ['pisnicky', 3]])
    LaTeX::chart("file1.png", "Chart caption")
    LaTeX::two_figures("file1.png", "file2.png", "Chart caption")
    LaTeX::two_charts("file1.png", "file2.png", "Chart caption")
  end
  
end