RSpec::Matchers.define :transition_from do |from_state|
  match do |obj|
    @state_machine_name ||= :default
    obj.aasm(@state_machine_name).current_state = from_state.to_sym
    # expect(obj).to receive(:broadcast_event).with(@event.to_s, obj, from_state, @to_state)
    obj.send(@event) && obj.aasm(@state_machine_name).current_state == @to_state.to_sym
  end

  chain :on do |state_machine_name|
    @state_machine_name = state_machine_name
  end

  chain :to do |state|
    @to_state = state
  end

  chain :on_event do |event|
    @event = event
  end

  description do
    "transition state to :#{@to_state} from :#{expected} on event :#{@event} (on :#{@state_machine_name})"
  end

  failure_message do |obj|
    "expected that :#{obj.aasm(@state_machine_name).current_state} would be :#{@to_state} (on :#{@state_machine_name})"
  end

  failure_message_when_negated do |obj|
    "expected that :#{obj.aasm(@state_machine_name).current_state} would not be :#{@to_state} (on :#{@state_machine_name})"
  end
end
