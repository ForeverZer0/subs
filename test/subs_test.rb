require "test_helper"

class SubsTest < Minitest::Test

  include Subs

  def test_that_it_has_a_version_number
    refute_nil ::Subs::VERSION
  end

  def test_it_connectes_to_osdb
    lang = Subs::Language.from_iso639_2('eng')
    assert OpenSubtitles.connect(lang)
  end
end
