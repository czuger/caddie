#
# I keep this because it is a very good example of fixture creation code
# 
# @region = create( :heimatar )
# next_process_date = Time.now.to_date
# objs = []
# 1.upto( 53 ).each do
#   item = create( :eve_item )
#
#   obj = create( :crest_price_history_update, region: @region, eve_item: item, next_process_date: next_process_date )
#   objs << obj
#
# end

# increment = 1
# File.open( 'test/fixtures/caddie/crest_price_history_updates.yml', 'w') do |f|
#   objs.each do |obj|
#     attrs = obj.attributes
#     attrs.delete_if{|k,v| v.blank?}
#
#     output = { 'r_' + increment.to_s => attrs}
#     f << output.to_yaml.gsub(/^--- \n/,'') + "\n"
#
#     increment += 1
#   end
# end
