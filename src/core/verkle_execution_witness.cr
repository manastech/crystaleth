module Pampero
  struct VerkleExecutionWitness
    property state_diff : Array(VerkleStateDiff)
    property verkle_proof : VerkleProof
  end

  struct VerkleStateDiff
    property stem : String
    property suffix_diffs : Array(SuffixDiff)
  end

  struct SuffixDiff
    property suffix : String
    property current_value : String
    property new_value : String
  end

  struct VerkleProof
    property commitments_by_path : Array(String)
    property d : String
    property depth_extension_present : String
    property ipa_proof : IpaProof
    property other_stems : Array(String)
  end

  struct IpaProof
    property cl : Array(String)
    property cr : Array(String)
    property final_evaluation : String
  end
end
