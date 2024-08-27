require "../common/types.cr"

module Pampero
  class VerkleState
    def initialize
      @state = Hash(Bytes32, Bytes32).new
      @pos_state = Hash(Bytes32, Bytes32).new
    end

    def init_execution_witness(execution_witness : VerkleExecutionWitness)
      execution_witness.state_diff.map do |state_diff|
        stem = state_diff.stem
        state_diff.suffix_diffs.map do |suffix_diff|
          suffix = suffix_diff.suffix
          if suffix.is_a?(String)
            is_hex = suffix[0] == '0' && (suffix[1].downcase == 'x')
            suffix = is_hex ? suffix[2..].to_i(16) : suffix.to_i
          end
          key = Bytes32.new sprintf("%s%02x", stem, suffix)

          current_value = get_leaf_value(suffix_diff.current_value)
          if current_value
            @state[key] = current_value
          else
            @state.delete key
          end

          new_value = get_leaf_value(suffix_diff.new_value)
          if new_value
            @pos_state[key] = new_value
          else
            @pos_state.delete key
          end
        end
      end
    end

    def get_leaf_value(leaf : String) : Bytes32
      Bytes32.new leaf
    end

    def get_leaf_value(leaf : LeafValue) : Bytes32?
      if value = leaf.value
        Bytes32.new(value)
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
