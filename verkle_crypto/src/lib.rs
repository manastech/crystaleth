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


// static context : Context = Context::new();

// #[no_mangle]
// pub extern "C" fn create_context() -> *const Context {
//   context : Context = Context::new();
//   &context
// }

#[repr(C)]
pub struct Bytes64 {
  data: [u8; 64]
}

#[repr(C)]
pub struct Bytes32 {
  data: [u8; 32]
}

#[no_mangle]
pub extern "C" fn hash(input : *const Bytes64, output: *mut Bytes32) {
  let data : [u8; 64];
  // let context : &Context;
  // let context : Context = Context::new();
  let crs = CRS::default();
  let committer = DefaultCommitter::new(&crs.G);

  println!("0------------ here");

  unsafe {
    // context = &*p_context;
    data = (*input).data;
  }

  println!("1------------ we {}", data[23]);

  let result = hash_safe(&committer, data);

  println!("2------------ go {}", result[22]);

  unsafe {
    (*output).data = result;
  }

  println!("3------------ here");
}

fn hash_safe(committer: &DefaultCommitter, input : [u8; 64]) -> [u8; 32] {
  verkle_spec::hash64(&committer, input).to_fixed_bytes()
}
