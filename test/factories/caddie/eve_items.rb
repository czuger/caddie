FactoryGirl.define do
  factory :eve_item, class: EveItem do
    cost 5
    involved_in_blueprint true

    sequence :cpp_eve_item_id do |n|
      n
    end
    sequence :name do |n|
      "Name #{n}"
    end
    sequence :name_lowcase do |n|
      "name #{n}"
    end
  end
end
