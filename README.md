# Subs

Subs aims for making fetching subtitles for all your favorite movies and television shows a few keystrokes away using a simple and intuitive command-line interface. It uses multiple search algorithms for determining the best matching subtitle for video files that it finds, including using provider hashing algorithms (preferred), filename and name, and IMDb IDs.

It currently ships with two primary providers that it can utilize, [SubDB](http://thesubdb.com/) and [OpenSubtitles](https://www.opensubtitles.org), as they both are open-source, and contain some of the largest collections of subtitles available anywhere. They both also expose a public API and custom hashing algorithm to drastically increase quality of results, and are much faster and more accurate than web-scraping. More providers will likely be added in the future.
 
Subs also comes with a utility for easily re-syncing existing SubRip (.srt) subtitle files if they do not match the video audio exactly. This feature is often included in video players, but this will allow for permanently saving the file with the corrected offset extremely easily.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'subs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install subs

## Usage

Once installed, open a terminal/command window and use the following basic syntax:
```
subs COMMAND [ARGUMENTS] [OPTIONS]
```

Subs can run in a fully-automatic mode that will can recursively search folders for video files, find matching subtitles, and download/rename them appropriately, or fully-manual one file at a time and you select the subtitle from a list, or anywhere in between, the choice is yours.

You are encouraged to the [Wiki](https://github.com/ForeverZer0/subs/wiki) for full explanation of each command, but you can see a list of available commands, use the following command:
```
subs --help
```
or...
```
subs --help COMMAND
```
...to see a brief explanation of the specified command and its options.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ForeverZer0/subs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Subs project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/osdb_client/blob/master/CODE_OF_CONDUCT.md).
