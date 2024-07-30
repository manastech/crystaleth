require "json"

module Pampero
  struct VerkleExecutionWitness
    include JSON::Serializable
    property state_diff : Array(VerkleStateDiff)
    property verkle_proof : VerkleProof
  end

  struct VerkleStateDiff
    include JSON::Serializable
    property stem : String
    property suffix_diffs : Array(SuffixDiff)
  end

  struct SuffixDiff
    include JSON::Serializable
    property suffix : UInt64
    property current_value : String?
    property new_value : String?
  end

  struct VerkleProof
    include JSON::Serializable
    property commitments_by_path : Array(String)
    property d : String
    property depth_extension_present : String
    property ipa_proof : IpaProof
    property other_stems : Array(String)
  end

  struct IpaProof
    include JSON::Serializable
    property cl : Array(String)
    property cr : Array(String)
    property final_evaluation : String
  end
end
