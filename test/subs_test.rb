require "test_helper"

class SubsTest < Minitest::Test

  include Subs

  def test_that_it_has_a_version
    refute_nil ::Subs::VERSION
  end

  def test_it_connectes_to_osdb
    lang = Subs::Language.from_iso639_2('eng')
    assert OpenSubtitles.connect(lang)
  end

  def test_osdb_hash_is_correct
    file = File.expand_path '~/Downloads/breakdance.avi'
    skip('source file was not found in Downloads folder') unless File.exist?(file)
    hash = OpenSubtitles.compute_hash(file)
    assert_equal('8e245d9679d31e12', hash)
  end

  def test_subdb_hash_is_correct
    file = File.expand_path '~/Downloads/dexter.mp4'
    skip('source file was not found in Downloads folder') unless File.exist?(file)
    hash = SubDB.compute_hash(file)
    assert_equal('ffd8d4aa68033dc03d1c8ef373b9028c', hash)
  end
end
