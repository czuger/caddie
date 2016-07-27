require 'thwait'

class Caddie::MThreadedUpdater

  # TODO : - split the work in database using thread_slice_id (set numbers : 1 .. MAX_THREADS)
  # TODO : Then run N threads each threads get the records associated to it's number

  def initialize( max_threads, daily_operations_list )
    @max_threads = max_threads
    @daily_operations_list = daily_operations_list
  end

  def run_threaded
    threads = []
    0.upto( @max_threads-1 ).each do |thread_id|
      threads << Thread.new {
        puts Caddie::CrestPriceHistoryUpdate.daily_operations_list.reload.count
        yield thread_id
      }
    end
    result = []
    ThreadsWait.all_waits( *threads ) do |t|
      thread_result = t[:timings]
      result << thread_result
    end
    result
  end

  def split_work_for_threads
    ids = @daily_operations_list.pluck( :id )
    ActiveRecord::Base.transaction do
      slice_size = ids.count/@max_threads + 1
      ( 0 ... @max_threads ).each do |thread_id|
        ids_slice = ids.shift( slice_size )
        @daily_operations_list.where( id: ids_slice ).update_all( thread_slice_id: thread_id )
      end
    end
  end

end