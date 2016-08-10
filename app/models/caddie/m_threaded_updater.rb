require 'thwait'
require 'matrix'

class Caddie::MThreadedUpdater

  # TODO : - split the work in database using thread_slice_id (set numbers : 1 .. MAX_THREADS)
  # TODO : Then run N threads each threads get the records associated to it's number

  def initialize( max_threads, daily_operations_list )
    @max_threads = max_threads
    @daily_operations_list = daily_operations_list
  end

  def feed_price_histories_threaded
    split_work_for_threads
    Thread::abort_on_exception = true
    threads = []
    0.upto( @max_threads-1 ).each do |thread_id|
      threads << Thread.new {
        Thread.current[:timings] = Caddie::CrestPriceHistoryUpdate.feed_price_histories( @threads_split[ thread_id ] )
      }
    end
    result = []
    ThreadsWait.all_waits( *threads ) do |t|
      thread_result = t[:timings]
      result << thread_result
    end
    results = result.map { |a| Vector[*a] }.inject(:+).to_a
    results[ 2 ] = result.map{ |e| e[2] }.max # For timings we are using the max, not the sum.
    results
  end

  def split_work_for_threads
    puts 'Start splitting work for threads'
    ids = @daily_operations_list.pluck( :id )
    @threads_split = []

    slice_size = ids.count/@max_threads + 1
    ( 0 ... @max_threads ).each do |thread_id|
      @threads_split[ thread_id ] = ids.shift( slice_size )
    end
    puts 'Finished splitting work for threads'
  end

end