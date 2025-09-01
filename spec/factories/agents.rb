FactoryBot.define do
  factory :agent do
    name { "MyString" }
    agent_type { "MyString" }
    tagline { "MyString" }
    description { "MyText" }
    personality_traits { "MyText" }
    capabilities { "MyText" }
    specializations { "MyText" }
    configuration { "MyText" }
    status { "MyString" }
  end
end
