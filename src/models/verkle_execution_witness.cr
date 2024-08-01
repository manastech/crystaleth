require "json"

module Pampero
  struct VerkleExecutionWitness
    include JSON::Serializable

    @[JSON::Field(key: "state_diff")]
    property state_diff_1 : Array(VerkleStateDiff)?
    @[JSON::Field(key: "stateDiff")]
    property state_diff_2 : Array(VerkleStateDiff)?

    @[JSON::Field(key: "verkle_proof")]
    property verkle_proof_1 : VerkleProof?
    @[JSON::Field(key: "verkleProof")]
    property verkle_proof_2 : VerkleProof?

    def state_diff : Array(VerkleStateDiff)
      unless result = state_diff_1 || state_diff_2
        raise "Invalid state_diff"
      end
      result
    end

    def verkle_proof : VerkleProof
      unless result = verkle_proof_1 || verkle_proof_2
        raise "Invalid verkle_proof"
      end
      result
    end
  end

  struct VerkleStateDiff
    include JSON::Serializable

    property stem : String

    @[JSON::Field(key: "suffix_diffs")]
    property suffix_diffs_1 : Array(SuffixDiff)?
    @[JSON::Field(key: "suffixDiffs")]
    property suffix_diffs_2 : Array(SuffixDiff)?

    def suffix_diffs
      unless result = suffix_diffs_1 || suffix_diffs_2
        raise "Invalid suffix_diffs"
      end
      result
    end
  end

  struct SuffixDiff
    include JSON::Serializable
    property suffix : UInt8 | String
    property current_value : String | LeafValue?
    property new_value : String | LeafValue?
  end

  struct LeafValue
    include JSON::Serializable

    @[JSON::Field(key: "Optional[]")]
    property value : String
  end

  struct VerkleProof
    include JSON::Serializable

    @[JSON::Field(key: "commitments_by_path")]
    property commitments_by_path_1 : Array(String)?
    @[JSON::Field(key: "commitmentsByPath")]
    property commitments_by_path_2 : Array(String)?

    property d : String

    @[JSON::Field(key: "depth_extension_present")]
    property depth_extension_present_1 : String?
    @[JSON::Field(key: "depthExtensionPresent")]
    property depth_extension_present_2 : String?

    @[JSON::Field(key: "ipa_proof")]
    property ipa_proof_1 : IpaProof?
    @[JSON::Field(key: "ipaProof")]
    property ipa_proof_2 : IpaProof?

    @[JSON::Field(key: "other_stems")]
    property other_stems_1 : Array(String)?
    @[JSON::Field(key: "otherStems")]
    property other_stems_2 : Array(String)?

    def commitments_by_path : Array(String)
      unless result = commitments_by_path_1 || commitments_by_path_2
        raise "Invalid commitments_by_path"
      end
      result
    end

    def depth_extension_present : String
      unless result = depth_extension_present_1 || depth_extension_present_2
        raise "Invalid depth_extension_present"
      end
      result
    end

    def ipa_proof : IpaProof
      unless result = ipa_proof_1 || ipa_proof_2
        raise "Invalid ipa_proof"
      end
      result
    end

    def other_stems : Array(String)
      unless result = other_stems_1 || other_stems_2
        raise "Invalid other_stems"
      end
      result
    end
  end

  struct IpaProof
    include JSON::Serializable

    property cl : Array(String)
    property cr : Array(String)

    @[JSON::Field(key: "final_evaluation")]
    property final_evaluation_1 : String?
    @[JSON::Field(key: "finalEvaluation")]
    property final_evaluation_2 : String?

    def final_evaluation : String
      unless result = final_evaluation_1 || final_evaluation_2
        raise "Invalid final_evaluation"
      end
      result
    end
  end
end
