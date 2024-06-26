use ipa_multipoint::committer::{Committer, DefaultCommitter};
use ipa_multipoint::crs::CRS;
use ipa_multipoint::lagrange_basis::PrecomputedWeights;

/// Context holds all of the necessary components needed for cryptographic operations
/// in the Verkle Trie. This includes:
/// - Updating the verkle trie
/// - Generating proofs
///
/// This is useful for caching purposes, since the context can be reused for multiple
/// function calls. More so because the Context is relatively expensive to create
/// compared to making a function call.
pub struct Context {
  pub crs: CRS,
  pub committer: DefaultCommitter,

  pub precomputed_weights: PrecomputedWeights,
}

impl Default for Context {
  fn default() -> Self {
      Self::new()
  }
}

impl Context {
  pub fn new() -> Self {
      let crs = CRS::default();
      let committer = DefaultCommitter::new(&crs.G);
      let precomputed_weights = PrecomputedWeights::new(256);

      Self {
          crs,
          committer,
          precomputed_weights,
      }
  }
}


#[no_mangle]
pub extern "C" fn create_context() -> *const Context {
  let context : Context = Context::new();
  &context
}

#[repr(C)]
pub struct Bytes64 {
  data: [u8; 64]
}

#[repr(C)]
pub struct Bytes32 {
  data: [u8; 32]
}

#[no_mangle]
pub extern "C" fn hash(p_context: *const Context, input : *const Bytes64, output: *mut Bytes32) {
  let data : [u8; 64];
  let context : &Context;
  unsafe {
    context = &*p_context;
    data = (*input).data;
  }
  let result = hash_safe(&context, data);
  unsafe {
    (*output).data = result;
  }
}

fn hash_safe(context: &Context, input : [u8; 64]) -> [u8; 32] {
  verkle_spec::hash64(&context.committer, input).to_fixed_bytes()
}
