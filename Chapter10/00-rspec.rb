RSpec.configure do |c|
  c.drb = true
  c.drb_port = 24601

  c.around do |spec|
    DB.transaction(rollback: :always, &spec)
  end
end

RSpec::Core::DRbRunner.new(port: 24601)

RSpec::Core::Hooks.register(:prepend, :around) do |spec|
  DB.transaction(rollback: :always, &spec)
end

module RSpec
  self.drb = true
  self.drb_port = 24601

  around do |spec|
    DB.transaction(rollback: :always, &spec)
  end
end

module RSpec
  drb = true
  drb_port = 24601
end

module RSpec
  set_drb true
  set_drb_port 24601
end

module RSpec
  drb true       # Set the value
  drb_port 24601 # Set the value
end
RSpec.drb
# => true
RSpec.drb_port
# => 24601

def RSpec.configure
  yield RSpec::Core::Configuration.new
end
