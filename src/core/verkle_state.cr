require "../common/types.cr"

module Pampero
  class VerkleState
    def initialize
      @state = Hash(Bytes32, Bytes32).new
    end

    def init_execution_witness(execution_witness : VerkleExecutionWitness)
      execution_witness.state_diff.map do |state_diff|
        stem = state_diff.stem
        state_diff.suffix_diffs.map do |suffix_diff|
          suffix = suffix_diff.suffix
          if suffix.is_a?(String)
            suffix = suffix[2..].to_i(16)
          end
          key = Bytes32.new sprintf("%s%02x", stem, suffix)
          current_value = suffix_diff.current_value
          unless current_value.nil?
             value = Bytes32.new(current_value.is_a?(String) ? current_value : current_value.value)
             @state[key] = value
          else
            @state.delete key
          end
        end
      end
    end

    def read_key(key : Bytes32) : Bytes32?
      @state.fetch key, nil
    end

    def write_key(key : Bytes32, data : Bytes32?)
      unless data.nil?
        @state[key] = data
      else
        @state.delete key
      end
    end
  end
end
