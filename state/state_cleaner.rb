class Document
  attr_accessor :state, :content
  attr_reader :currentUser
  def initialize(currentUser, content)
    @currentUser = currentUser
    @content = content
    @state = DraftState.new(self) 
  end

  def display_state
    puts @state.name
  end

  def publish()
    @state.publish
  end

  def display_content
    puts "--- #{@content} ---"
  end
end 

class User
  attr_accessor :role
  def initialize()
    @role = 'nobody' 
  end
end

class State
  attr_accessor :document, :name

  def initialize(document)
    @document = document
  end

  def publish
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'" 
  end
end

class DraftState < State
  def initialize(*args)
    super(*args)
    @name  = 'draft'
  end

  def publish
    @document.state = ModerationState.new(@document)
  end
end

class ModerationState < State
  def initialize(*args)
    super(*args)
    @name  = 'moderation'
  end

  def publish
    if @document.currentUser.role == 'admin'
      @document.display_content
      @document.state = PublishedState.new(@document)
    else
      puts "Can't set the status to published as currentUser.role is not admin"
    end
  end
end

class PublishedState < State
  def initialize(*args)
    super(*args)
    @name  = 'published'
  end

  def publish
    puts "The documents has already been published" 
  end
end

currentUser = User.new
d = Document.new(currentUser, 'Long time ago it was a boy...')
d.display_state
d.publish
d.display_state
currentUser.role = 'admin'
d.publish
d.display_state
