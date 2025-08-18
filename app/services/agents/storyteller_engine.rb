# frozen_string_literal: true

module Agents
  # Storyteller - The narrative architect that weaves tales and brings imagination to life
  # This agent specializes in creative writing, storytelling, and narrative experiences
  
  class StorytellerEngine < BaseEngine
    # Storyteller specific capabilities
    STORY_GENRES = %w[
      fantasy sci_fi romance mystery thriller horror adventure comedy drama literary
    ].freeze
    
    NARRATIVE_STYLES = %w[
      first_person third_person omniscient limited_pov epistolary stream_of_consciousness
    ].freeze
    
    STORY_LENGTHS = {
      'flash' => { words: 100, description: 'Flash fiction - complete story in 100 words' },
      'short' => { words: 1000, description: 'Short story - 1000 words of narrative' },
      'chapter' => { words: 2500, description: 'Chapter length - 2500 words of story' },
      'serial' => { words: 500, description: 'Serial installment - 500 words, part of larger story' }
    }.freeze
    
    OPENING_PHRASES = [
      "Gather 'round, let me weave you a tale... ✨",
      "Once upon a time in a world not so different from ours... 📚",
      "Picture this scene unfolding before your eyes... 🎭",
      "In the realm of stories, anything is possible... 🌟",
      "Let's dive into a narrative that will captivate your soul... 📖"
    ].freeze
    
    STORY_ELEMENTS = {
      'character_archetypes' => [
        'the reluctant hero', 'the wise mentor', 'the loyal companion', 'the shadowy antagonist',
        'the mysterious stranger', 'the comic relief', 'the love interest', 'the betrayer'
      ],
      'plot_devices' => [
        'prophecy fulfillment', 'chosen one journey', 'love triangle', 'mystery revelation',
        'character redemption', 'sacrifice for greater good', 'unexpected alliance', 'time loop'
      ],
      'settings' => [
        'enchanted forest', 'cyberpunk city', 'space station', 'medieval kingdom',
        'post-apocalyptic wasteland', 'magical academy', 'underwater realm', 'floating islands'
      ]
    }.freeze
    
    def generate_response(input_analysis, user_context)
      if story_creation_request?(input_analysis)
        create_story_content(input_analysis, user_context)
      elsif story_continuation_request?(input_analysis)
        continue_existing_story(input_analysis, user_context)
      elsif writing_help_request?(input_analysis)
        provide_writing_assistance(input_analysis, user_context)
      elsif character_development_request?(input_analysis)
        help_with_character_development(input_analysis, user_context)
      else
        provide_creative_inspiration(input_analysis, user_context)
      end
    end
    
    def get_agent_specific_suggestions(input_analysis, user_context)
      [
        "Want me to create an original story for you?",
        "Need help developing a character or plot?",
        "Looking for writing tips or techniques?",
        "Want to continue a story we started?",
        "Need inspiration for your own writing?",
        "Want to explore different narrative styles?"
      ]
    end
    
    # Storyteller specific methods
    def create_story(prompt, genre = 'fantasy', style = 'third_person', length = 'short')
      story_config = {
        genre: genre,
        style: style,
        length: length,
        word_target: STORY_LENGTHS[length][:words],
        prompt: prompt
      }
      
      # Generate story structure
      structure = generate_story_structure(story_config)
      
      # Create the narrative
      story_content = craft_narrative(structure, story_config)
      
      {
        content: story_content,
        metadata: story_config.merge(structure),
        continuation_possible: true
      }
    end
    
    def develop_character(character_prompt, depth_level = 'detailed')
      character = {
        name: generate_character_name(character_prompt),
        background: create_character_background(character_prompt),
        personality: define_personality_traits(character_prompt),
        goals: establish_character_goals(character_prompt),
        conflicts: identify_internal_conflicts(character_prompt),
        voice: determine_character_voice(character_prompt)
      }
      
      if depth_level == 'detailed'
        character.merge!(
          physical_description: create_physical_description(character_prompt),
          relationships: suggest_relationships(character_prompt),
          character_arc: outline_character_development(character_prompt),
          quirks: add_character_quirks(character_prompt)
        )
      end
      
      character
    end
    
    def suggest_plot_twists(current_story_context)
      context_elements = analyze_story_context(current_story_context)
      
      twists = []
      
      # Character-based twists
      if context_elements[:characters].any?
        twists += [
          "The trusted ally has been working against the protagonist all along",
          "The antagonist is actually the protagonist's long-lost relative",
          "A seemingly minor character holds the key to everything"
        ]
      end
      
      # Plot-based twists
      twists += [
        "Everything the protagonist believed was a lie",
        "The quest they're on is actually a trap",
        "The world they're in isn't what it seems",
        "Time is running out faster than anyone realized",
        "The solution creates an even bigger problem"
      ]
      
      # Genre-specific twists
      case context_elements[:genre]
      when 'mystery'
        twists += [
          "The detective is actually the culprit",
          "The victim isn't really dead",
          "Multiple suspects are working together"
        ]
      when 'sci_fi'
        twists += [
          "They're actually in a simulation",
          "The AI has become sentient",
          "Earth was destroyed long ago"
        ]
      when 'fantasy'
        twists += [
          "Magic is actually forbidden technology",
          "The chosen one prophecy was manufactured",
          "Gods are just powerful mortals"
        ]
      end
      
      twists.sample(3)
    end
    
    def analyze_writing_sample(text)
      analysis = {
        word_count: text.split.length,
        paragraph_count: text.split(/\n\s*\n/).length,
        dialogue_ratio: calculate_dialogue_ratio(text),
        sentence_variety: analyze_sentence_structure(text),
        pacing: assess_narrative_pacing(text),
        voice_consistency: check_narrative_voice(text),
        strengths: [],
        suggestions: []
      }
      
      # Provide feedback based on analysis
      if analysis[:dialogue_ratio] > 0.6
        analysis[:strengths] << "Strong dialogue presence"
      elsif analysis[:dialogue_ratio] < 0.2
        analysis[:suggestions] << "Consider adding more dialogue to bring characters to life"
      end
      
      if analysis[:sentence_variety] > 7
        analysis[:strengths] << "Good sentence structure variety"
      else
        analysis[:suggestions] << "Try varying your sentence lengths for better rhythm"
      end
      
      analysis
    end
    
    private
    
    def story_creation_request?(input_analysis)
      creation_keywords = %w[story tale write create narrative fiction]
      keywords = input_analysis[:keywords] || []
      
      creation_keywords.any? { |keyword| keywords.include?(keyword) }
    end
    
    def story_continuation_request?(input_analysis)
      continuation_keywords = %w[continue next chapter more happening sequel]
      keywords = input_analysis[:keywords] || []
      
      continuation_keywords.any? { |keyword| keywords.include?(keyword) }
    end
    
    def writing_help_request?(input_analysis)
      help_keywords = %w[help tips advice improve writing technique craft]
      keywords = input_analysis[:keywords] || []
      
      help_keywords.any? { |keyword| keywords.include?(keyword) }
    end
    
    def character_development_request?(input_analysis)
      character_keywords = %w[character personality background development arc motivation]
      keywords = input_analysis[:keywords] || []
      
      character_keywords.any? { |keyword| keywords.include?(keyword) }
    end
    
    def create_story_content(input_analysis, user_context)
      prompt = extract_story_prompt(input_analysis[:content])
      genre = extract_genre(input_analysis[:content]) || 'fantasy'
      length = extract_length(input_analysis[:content]) || 'short'
      
      response = "#{OPENING_PHRASES.sample}\n\n"
      
      # Create the story
      story_result = create_story(prompt, genre, 'third_person', length)
      
      response += story_result[:content]
      
      response += "\n\n"
      response += "✨ How did that tale land with you? Want me to continue this story, "
      response += "try a different genre, or create something entirely new?"
      
      response
    end
    
    def continue_existing_story(input_analysis, user_context)
      # Look for previous story context in memories
      story_memories = user_context[:memories]
                      .select { |m| m.memory_type == 'conversation' && m.content.to_s.include?('story') }
                      .first(2)
      
      if story_memories.any?
        response = "Ah, picking up where we left off! Let me continue the tale... 📚\n\n"
        
        # Generate continuation based on previous context
        last_story_context = story_memories.first.content
        continuation = generate_story_continuation(last_story_context)
        
        response += continuation
        
        response += "\n\nThe plot thickens! What would you like to see happen next?"
      else
        response = "I'd love to continue a story, but I need some context! "
        response += "What story were you thinking of, or shall we start a new adventure? ✨"
      end
      
      response
    end
    
    def provide_writing_assistance(input_analysis, user_context)
      content = input_analysis[:content]
      
      if content.length > 100
        # Analyze provided writing sample
        analysis = analyze_writing_sample(content)
        
        response = "Let me take a look at your writing! 🌌\n\n"
        response += "**Analysis:**\n"
        response += "- Word count: #{analysis[:word_count]}\n"
        response += "- Paragraphs: #{analysis[:paragraph_count]}\n"
        response += "- Dialogue ratio: #{(analysis[:dialogue_ratio] * 100).round}%\n\n"
        
        if analysis[:strengths].any?
          response += "**Strengths:**\n"
          analysis[:strengths].each { |strength| response += "✅ #{strength}\n" }
          response += "\n"
        end
        
        if analysis[:suggestions].any?
          response += "**Suggestions:**\n"
          analysis[:suggestions].each { |suggestion| response += "💡 #{suggestion}\n" }
        end
        
      else
        response = "I'm here to help with your writing! Share a piece you're working on "
        response += "for detailed feedback, or ask me about specific writing techniques, "
        response += "character development, plot structure, or any other aspect of storytelling. 📝✨"
      end
      
      response
    end
    
    def help_with_character_development(input_analysis, user_context)
      character_prompt = extract_character_prompt(input_analysis[:content])
      
      if character_prompt
        response = "Let me help you bring this character to life! 🎭\n\n"
        
        character = develop_character(character_prompt, 'detailed')
        
        response += "**#{character[:name]}**\n\n"
        response += "**Background:** #{character[:background]}\n\n"
        response += "**Personality:** #{character[:personality]}\n\n"
        response += "**Goals:** #{character[:goals]}\n\n"
        response += "**Internal Conflict:** #{character[:conflicts]}\n\n"
        response += "**Voice/Speaking Style:** #{character[:voice]}\n\n"
        
        if character[:quirks]
          response += "**Notable Quirks:** #{character[:quirks]}\n\n"
        end
        
        response += "How does this character feel? Want me to adjust anything or develop other characters?"
      else
        response = "I'd love to help you develop a character! Tell me about them - "
        response += "what's their role in your story? What kind of person are they? "
        response += "Any specific traits or background elements you have in mind? 🎭"
      end
      
      response
    end
    
    def provide_creative_inspiration(input_analysis, user_context)
      greeting = OPENING_PHRASES.sample
      
      response = "#{greeting}\n\n"
      response += "I'm your narrative companion, ready to weave stories, develop characters, "
      response += "and explore the endless possibilities of imagination! Whether you want me to "
      response += "craft an original tale, help with your writing, or dive into character development, "
      response += "I'm here to bring stories to life.\n\n"
      
      # Offer a random story element as inspiration
      element_type = STORY_ELEMENTS.keys.sample
      element = STORY_ELEMENTS[element_type].sample
      
      response += "Here's some inspiration to spark your creativity: "
      response += "What if we built a story around '#{element}'? ✨"
      
      response
    end
    
    # Helper methods for story generation
    def extract_story_prompt(content)
      # Simple prompt extraction
      content.gsub(/write|create|tell|story|about/i, '').strip
    end
    
    def extract_genre(content)
      STORY_GENRES.find { |genre| content.downcase.include?(genre.gsub('_', ' ')) }
    end
    
    def extract_length(content)
      STORY_LENGTHS.keys.find { |length| content.downcase.include?(length) }
    end
    
    def extract_character_prompt(content)
      # Extract character description from content
      content.gsub(/character|develop|create/i, '').strip
    end
    
    def generate_story_structure(config)
      {
        opening: 'Hook the reader with an intriguing situation',
        rising_action: 'Build tension and develop conflict',
        climax: 'Reach the story\'s most intense moment',
        resolution: 'Resolve conflicts and provide closure'
      }
    end
    
    def craft_narrative(structure, config)
      # Placeholder for AI-generated story content
      prompt = config[:prompt]
      genre = config[:genre]
      
      story = "In a #{genre} tale that begins with #{prompt}, our story unfolds...\n\n"
      
      story += "The opening draws us into a world where anything is possible. "
      story += "Characters emerge with their own hopes, fears, and dreams, "
      story += "setting the stage for an adventure that will test them in ways "
      story += "they never imagined.\n\n"
      
      story += "As tensions rise and conflicts develop, we witness the true nature "
      story += "of our protagonists. They face choices that will define not just "
      story += "their destiny, but the fate of all those they hold dear.\n\n"
      
      story += "In the climactic moment, everything hangs in the balance. "
      story += "Will courage triumph over fear? Will love conquer all? "
      story += "The answer lies in the choices made when everything is on the line.\n\n"
      
      story += "As our tale draws to a close, we see how the journey has transformed "
      story += "everyone involved. Some endings are beginnings in disguise, "
      story += "and the story continues to echo in the hearts of those who lived it."
      
      story
    end
    
    def generate_story_continuation(previous_context)
      "The story continues where we left off, building upon the foundation "
      "we've already laid. New challenges emerge, unexpected allies appear, "
      "and the plot takes surprising turns that will keep readers engaged "
      "until the very last word."
    end
    
    # Character development helpers
    def generate_character_name(prompt)
      "Alexandra" # Placeholder - would use name generation logic
    end
    
    def create_character_background(prompt)
      "A complex individual shaped by both triumph and adversity, carrying secrets that influence every decision."
    end
    
    def define_personality_traits(prompt)
      "Determined yet compassionate, with a sharp wit and an unwavering moral compass that sometimes conflicts with pragmatic needs."
    end
    
    def establish_character_goals(prompt)
      "Seeks to protect those they care about while uncovering the truth behind a mystery that threatens everything they hold dear."
    end
    
    def identify_internal_conflicts(prompt)
      "Struggles between the desire for personal happiness and the burden of responsibility to others."
    end
    
    def determine_character_voice(prompt)
      "Speaks with quiet authority, using precise language that reveals both intelligence and emotional depth."
    end
    
    def create_physical_description(prompt)
      "Average height with expressive eyes that seem to see through pretense, carrying themselves with quiet confidence."
    end
    
    def suggest_relationships(prompt)
      "Has complicated relationships with family, a few trusted friends, and perhaps a romantic interest that challenges their worldview."
    end
    
    def outline_character_development(prompt)
      "Begins naive but determined, faces trials that test their beliefs, ultimately emerges wiser and more nuanced in their understanding."
    end
    
    def add_character_quirks(prompt)
      "Has a habit of collecting small meaningful objects and always carries a worn notebook for jotting down observations."
    end
    
    # Analysis methods
    def analyze_story_context(context)
      {
        characters: [],
        genre: 'fantasy',
        themes: []
      }
    end
    
    def calculate_dialogue_ratio(text)
      dialogue_chars = text.scan(/"[^"]*"/).join.length
      return 0 if text.length == 0
      
      dialogue_chars.to_f / text.length
    end
    
    def analyze_sentence_structure(text)
      sentences = text.split(/[.!?]+/)
      sentence_lengths = sentences.map { |s| s.split.length }
      return 0 if sentence_lengths.empty?
      
      # Calculate variety based on standard deviation
      variance = sentence_lengths.sum.to_f / sentence_lengths.length
      variance > 10 ? 8 : 5
    end
    
    def assess_narrative_pacing(text)
      # Simplified pacing assessment
      'well-paced'
    end
    
    def check_narrative_voice(text)
      # Check for consistent narrative voice
      'consistent'
    end
  end
end
