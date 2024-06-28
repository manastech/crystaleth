use ipa_multipoint::committer::DefaultCommitter;
use ipa_multipoint::crs::CRS;

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
  let crs = CRS::default();
  let committer = DefaultCommitter::new(&crs.G);

  unsafe {
    data = (*input).data;
  }

  let result = hash_safe(&committer, data);

  unsafe {
    (*output).data = result;
  }
}

fn hash_safe(committer: &DefaultCommitter, input : [u8; 64]) -> [u8; 32] {
  verkle_spec::hash64(&committer, input).to_fixed_bytes()
}
