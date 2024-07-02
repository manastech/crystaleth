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
          key = Bytes32.new sprintf("%s%02x", stem, suffix)
          current_value = suffix_diff.current_value
          # new_value = suffix_diff.new_value
          unless current_value.nil?
            @state[key] = Bytes32.new(current_value)
          else
            @state.delete key
          end
        end
      end
    end

    def read_key(key : Bytes32) : Bytes32
      @state.fetch key, Bytes32.new(0_u8)
    end
  end
end
