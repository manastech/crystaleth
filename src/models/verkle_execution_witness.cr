require "json"

module Pampero
  struct VerkleExecutionWitness
    include JSON::Serializable

    @[JSON::Field(key: "stateDiff")]
    property state_diff : Array(VerkleStateDiff)
    @[JSON::Field(key: "verkleProof")]
    property verkle_proof : VerkleProof
  end

  struct VerkleStateDiff
    include JSON::Serializable
    property stem : String
    @[JSON::Field(key: "suffixDiffs")]
    property suffix_diffs : Array(SuffixDiff)
  end

  struct SuffixDiff
    include JSON::Serializable
    property suffix : UInt64
    @[JSON::Field(key: "currentValue")]
    property current_value : String?
    @[JSON::Field(key: "newValue")]
    property new_value : String?
  end

  struct VerkleProof
    include JSON::Serializable
    @[JSON::Field(key: "commitmentsByPath")]
    property commitments_by_path : Array(String)
    property d : String
    @[JSON::Field(key: "depthExtensionPresent")]
    property depth_extension_present : String
    @[JSON::Field(key: "ipaProof")]
    property ipa_proof : IpaProof
    @[JSON::Field(key: "otherStems")]
    property other_stems : Array(String)
  end

  struct IpaProof
    include JSON::Serializable
    property cl : Array(String)
    property cr : Array(String)
    @[JSON::Field(key: "finalEvaluation")]
    property final_evaluation : String
  end
end
