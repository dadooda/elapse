
Elapsed time measurement tool
=============================

Introduction
------------

`Elapse` is a simple tool to measure time taken by various parts of your program.


Setup
-----

~~~
$ gem install elapse
~~~

, or via Bundler's `Gemfile`:

~~~
gem "elapse"
#gem "elapse", :git => "git://github.com/dadooda/elapse.git"     # Edge version.
~~~


Usage
-----

The most common use case is the "stacked" (or "unnamed") mode. In stacked mode you invoke `Elapse.start` and `Elapse.took` without arguments:

~~~
puts "Fetching page (url:'#{url}')"; Elapse.start
content = open(url).read
puts "Fetching page ok (took:%.2fs)" % Elapse.took
~~~

In stacked mode time is **pushed to the stack** on `Elapse.start` and **popped from the stack** on `Elapse.took`/`Elapse.stop`. Thus you can nest unnamed measurements as deep as you like:

~~~
puts "Processing"; Elapse.start
  puts "Loading data"; Elapse.start
  load_data
  puts "Loading data ok (took:%.2fs)" % Elapse.took

  puts "Converting data"; Elapse.start
  process_data
  puts "Converting data ok (took:%.2fs)" % Elapse.took
puts "Processing ok (took:%.2fs)" % Elapse.took

# Output:

Processing
Loading data
Loading data ok (took:2.00s)
Converting data
Converting data ok (took:3.00s)
Processing ok (took:5.00s)
~~~

"Named" mode. See the stopwatch name argument to `Elapse.start`, `Elapse.stop` and `Elapse.took`:

~~~
Elapse.start(:load_data)
load_data
Elapse.stop(:load_data)

Elapse.start(:process_data)
process_data
Elapse.stop(:process_data)

puts "Time took:"
[:load_data, :process_data].each do |stopwatch|
  puts "* #{stopwatch}: %.2fs" % Elapse.took(stopwatch)
end

# Output:

Time took:
* load_data: 2.00s
* process_data: 3.00s
~~~

In named mode you cat get **cumulative time** measured by the stopwatch:

~~~
filenames.each do |fn|
  puts "Processing file (fn:'#{fn}')"; Elapse.start(:process_file)
  process_file(fn)
  puts "Processing file ok (took:%.2fs)" % Elapse.took(:process_file)
end

puts "Total file processing took %.2fs" % Elapse.cumulative(:process_file)
~~~

That's it for the basic intro. See the full [RDoc documentation](http://rubydoc.info/github/dadooda/elapse/master/frames) for more details.


Compatibility
-------------

Tested to run on:

* Ruby 1.9.2-p180, Linux, RVM

Compatibility issue reports will be greatly appreciated.


Copyright
---------

Copyright &copy; 2012 Alex Fortuna.

Licensed under the MIT License.


Feedback
--------

Send bug reports, suggestions and criticisms through [project's page on GitHub](http://github.com/dadooda/elapse).
