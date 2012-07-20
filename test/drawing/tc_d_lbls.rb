require 'tc_helper'

class TestDLbls < Test::Unit::TestCase

  def setup
    @d_lbls = Axlsx::DLbls.new
  end

  def test_initialization
    assert_equal(:best_fit, @d_lbls.d_lbl_pos)
    Axlsx::DLbls::BOOLEAN_ATTRIBUTES.each do |attr|
      assert_equal(false, @d_lbls.send(attr))
    end
  end

  def test_d_lbl_pos
    assert_raise(ArgumentError, 'invlaid label positions are rejected') { @d_lbls.d_lbl_pos = :upside_down }
    assert_nothing_raised('accepts valid label position') { @d_lbls.d_lbl_pos = :ctr }
  end

  def test_boolean_attributes
    Axlsx::DLbls::BOOLEAN_ATTRIBUTES.each do |attr|
      assert_raise(ArgumentError, "rejects non boolean value for #{attr}") { @d_lbls.send("#{attr}=", :foo) }
      assert_nothing_raised("accepts boolean value for #{attr}") { @d_lbls.send("#{attr}=", true) }
      assert_nothing_raised("accepts boolean value for #{attr}") { @d_lbls.send("#{attr}=", false) }
    end
  end

  def test_to_xml_string
      str = '<?xml version="1.0" encoding="UTF-8"?>'
      str << '<c:chartSpace xmlns:c="' << Axlsx::XML_NS_C << '" xmlns:a="' << Axlsx::XML_NS_A << '" xmlns:r="' << Axlsx::XML_NS_R << '">'
      @d_lbls.to_xml_string(str) 
      str << '</c:chartSpace>'
      doc = Nokogiri::XML(str)
      @d_lbls.instance_values.each do |name, value|
        assert(doc.xpath("//c:#{Axlsx::camel(name, false)}[@val='#{value}']"), "#{name} is properly serialized")
      end
  end
end