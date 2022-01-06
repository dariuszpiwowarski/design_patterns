class Document
  AVAILABLE_STATES = ["draft", "moderation", "published"]
  DEFAULT_STATE = "draft"
  def initialize(currentUser)
    @state = DEFAULT_STATE
    @currentUser = currentUser 
  end

  def publish()
    case @state
    when 'draft'
      set_state('moderation')
    when 'moderation'
      if @currentUser.role == 'admin'
        set_state('published')
      else
        puts "Can't set the state to published as currentUser.role is not admin"
      end
    when 'published'
       puts "The documents has already been published" 
    end 
  end

  def set_state(state)
    raise "Not supported state: '#{state}'" unless AVAILABLE_STATES.include?(state)
    @state = state
  end

  def display_state
    puts @state
  end
end

class User
  attr_accessor :role
  def initialize()
    @role = 'nobody' 
  end
end

currentUser = User.new
d = Document.new(currentUser)
d.display_state
d.publish
d.display_state
d.publish
currentUser.role = 'admin'
d.display_state
d.publish
d.display_state
d.publish
d.display_state

