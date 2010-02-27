Factory.define :weaving_type do |f|
  f.sequence(:name) { |n| "Shawl#{n}" }
  f.published true
end

Factory.define :wool_type do |f|
  f.sequence(:name) { |n| "Sheep#{n}" }
  f.published true
end

Factory.define :weaver do |f|
  f.sequence(:name) { |n| "Bob#{n}" }
  f.published true
end

Factory.define :weaving do |f|
  f.sequence(:item_number) { |n| "W00#{n}" }
  f.weaving_type { |weaving_type| weaving_type.association(:weaving_type) }
  f.wool_type { |wool_type| wool_type.association(:wool_type) }
  f.weaver { |weaver| weaver.association(:weaver) }
  f.description 'Weaving description goes here.'
end
