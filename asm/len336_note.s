// args:
// 0x00  scalar_type*             inout
// 0x08  size_t                   nbatch
// 0x10  const scalar_type* const twiddles
// 0x18  size_t                   dim
// 0x20  const size_t* const      lengths
// 0x28  const size_t* const      stride

<void forward_length336<HIP_vector_type<double, 2u> >(HIP_vector_type<double, 2u>*, unsigned long, HIP_vector_type<double, 2u> const*, unsigned long, unsigned long const*, unsigned long const*)>:
; void forward_length336<HIP_vector_type<double, 2u> >(HIP_vector_type<double, 2u>*, unsigned long, HIP_vector_type<double, 2u> const*, unsigned long, unsigned long const*, unsigned long const*)():
;   std::uint32_t operator()(std::uint32_t x) const noexcept { return __ockl_get_group_id(x); }
	s_load_dwordx8 s[8:15], s[4:5], 0x0
	s_load_dwordx4 s[0:3], s[4:5], 0x20
	s_mov_b64 s[4:5], 1
;     for(d = 1; d < dim; ++d)
	s_waitcnt lgkmcnt(0)
	v_cmp_lt_u64_e64 s[16:17], s[14:15], 2
	s_and_b64 vcc, exec, s[16:17]
	s_cbranch_vccnz BB2_3
	s_add_u32 s16, s14, -1
	s_addc_u32 s17, s15, -1
	s_add_u32 s0, s0, 8 // length++, so it's now at lengths[1]
	s_addc_u32 s1, s1, 0
	s_mov_b64 s[4:5], 1 // plength

<BB2_2>:
;         plength   = plength * lengths[d]; /* stockham-generator:193 */
	s_load_dwordx2 s[18:19], s[0:1], 0x0 // load length[d]
	s_waitcnt lgkmcnt(0)
	// plength *= lengths[d]
	s_mul_i32 s5, s18, s5    // s[4:5] * s[18:19]
	s_mul_hi_u32 s7, s18, s4 // s[4:5] * s[18:19]
	s_mul_i32 s19, s19, s4   // s[4:5] * s[18:19]
	s_add_i32 s5, s7, s5     // s[4:5] * s[18:19]
	s_add_i32 s5, s5, s19    // s[4:5] * s[18:19]
;     for(d = 1; d < dim; ++d)
	s_add_u32 s16, s16, -1
	s_addc_u32 s17, s17, -1
	s_add_u32 s0, s0, 8 // length++
	s_addc_u32 s1, s1, 0
	s_cmp_lg_u64 s[16:17], 0 
;         plength   = plength * lengths[d]; /* stockham-generator:193 */
	s_mul_i32 s4, s18, s4    // s[4:5] * s[18:19]
	s_cbranch_scc1 BB2_2

<BB2_3>:
;     transform = blockIdx.x * 4 + threadIdx.x / 56; /* stockham-generator:189 */
	v_lshrrev_b32_e32 v1, 3, v0
	s_mov_b32 s0, 0x24924925
	v_mul_hi_u32 v1, v1, s0
	v_mov_b32_e32 v3, 0
	v_lshl_add_u32 v2, s6, 2, v1
;     batch = transform / plength; /* stockham-generator:199 */
	v_cmp_le_u64_e32 vcc, s[4:5], v[2:3]
	v_mov_b32_e32 v3, 0
	v_mov_b32_e32 v4, 0
	s_and_saveexec_b64 s[0:1], vcc
	s_cbranch_execnz BB2_6
	s_or_b64 exec, exec, s[0:1]
;     if(batch >= nbatch)
	v_cmp_gt_u64_e32 vcc, s[10:11], v[3:4]
	s_and_saveexec_b64 s[0:1], vcc
	s_cbranch_execnz BB2_7

<BB2_5>:
; }
	s_endpgm

<BB2_6>:
;     batch = transform / plength; /* stockham-generator:199 */
	v_cvt_f32_u32_e32 v3, s4
	s_sub_i32 s5, 0, s4
	v_rcp_iflag_f32_e32 v3, v3
	v_mul_f32_e32 v3, 0x4f7ffffe, v3
	v_cvt_u32_f32_e32 v3, v3
	v_mul_lo_u32 v4, s5, v3
	v_mul_hi_u32 v4, v3, v4
	v_add_u32_e32 v3, v3, v4
	v_mul_hi_u32 v3, v2, v3
	v_mul_lo_u32 v4, v3, s4
	v_add_u32_e32 v5, 1, v3
	v_sub_u32_e32 v4, v2, v4
	v_cmp_le_u32_e32 vcc, s4, v4
	v_subrev_u32_e32 v6, s4, v4
	v_cndmask_b32_e32 v3, v3, v5, vcc
	v_cndmask_b32_e32 v4, v4, v6, vcc
	v_cmp_le_u32_e32 vcc, s4, v4
	v_add_u32_e32 v5, 1, v3
	v_cndmask_b32_e32 v3, v3, v5, vcc
	v_mov_b32_e32 v4, 0
	s_or_b64 exec, exec, s[0:1]
;     if(batch >= nbatch)
	v_cmp_gt_u64_e32 vcc, s[10:11], v[3:4]
	s_and_saveexec_b64 s[0:1], vcc
	s_cbranch_execz BB2_5

<BB2_7>:
;     offset     = offset + batch * stride[dim]; /* stockham-generator:203 */
	s_lshl_b64 s[0:1], s[14:15], 3
	s_add_u32 s0, s2, s0
	s_addc_u32 s1, s3, s1
	s_load_dwordx2 s[0:1], s[0:1], 0x0
	v_mul_lo_u32 v1, v1, 56
	s_mov_b32 s2, 0xe8584caa
	s_mov_b32 s3, 0x3febb67a
	s_mov_b32 s5, 0xbfebb67a
	s_waitcnt lgkmcnt(0)
	v_mul_lo_u32 v4, s1, v3
	v_mul_hi_u32 v5, s0, v3
	v_mul_lo_u32 v3, s0, v3
	v_sub_u32_e32 v6, v0, v1
;         HIP_vector_type& operator=(const HIP_vector_type&) = default;
	s_movk_i32 s0, 0x1000
;     offset     = offset + batch * stride[dim]; /* stockham-generator:203 */
	v_add_u32_e32 v1, v5, v4
;     R[0] = inout[offset + thread + 0]; /* generator.py:1004 */
	v_add_co_u32_e32 v0, vcc, v3, v6
	v_addc_co_u32_e32 v1, vcc, 0, v1, vcc
	v_lshlrev_b64 v[0:1], 4, v[0:1]
	v_mov_b32_e32 v3, s9
	v_add_co_u32_e32 v0, vcc, s8, v0
	v_addc_co_u32_e32 v1, vcc, v3, v1, vcc
;         HIP_vector_type& operator=(const HIP_vector_type&) = default;
	v_add_co_u32_e32 v3, vcc, s0, v0
	global_load_dwordx4 v[9:12], v[0:1], off
	global_load_dwordx4 v[13:16], v[0:1], off offset:896
	v_addc_co_u32_e32 v4, vcc, 0, v1, vcc
	global_load_dwordx4 v[17:20], v[0:1], off offset:1792
	global_load_dwordx4 v[21:24], v[0:1], off offset:2688
	global_load_dwordx4 v[29:32], v[3:4], off offset:384
	global_load_dwordx4 v[25:28], v[0:1], off offset:3584
	s_mov_b32 s4, s2
	s_mov_b32 s1, 0xaaab
;         lds[offset_lds + (thread / 6) * 42 + thread % 6 + 0]  = R[0]; /* stockham-generator:129 */
	v_mul_u32_u24_sdwa v4, v6, s1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:BYTE_0 src1_sel:DWORD
	v_lshrrev_b32_e32 v7, 18, v4
;         lds[offset_lds + (thread / 1) * 6 + thread % 1 + 0] = R[0]; /* stockham-generator:129 */
	v_mul_lo_u32 v3, v6, 6
	v_mul_lo_u16_e32 v4, 6, v7
;     offset_lds = 336 * (transform % 4); /* stockham-generator:204 */
	v_and_b32_e32 v2, 3, v2
	s_movk_i32 s0, 0xff
	v_sub_u16_e32 v4, v6, v4
	v_mul_u32_u24_e32 v5, 0x150, v2
;     W    = twiddles[5 + 6 * (thread % 6)]; /* stockham-generator:101 */
	v_and_b32_e32 v8, s0, v4
	v_add_lshl_u32 v49, v5, v3, 4
	v_mul_u32_u24_e32 v3, 6, v8
	v_lshlrev_b32_e32 v53, 4, v3
;         __atomic_work_item_fence(flags, __memory_order_release, scope);
	s_waitcnt vmcnt(0) lgkmcnt(0)
;         __builtin_amdgcn_s_barrier();
	s_barrier
;         __atomic_work_item_fence(flags, __memory_order_acquire, scope);
	s_waitcnt lgkmcnt(0)
;         __atomic_work_item_fence(flags, __memory_order_release, scope);
	s_waitcnt lgkmcnt(0)
;         __builtin_amdgcn_s_barrier();
	s_barrier
;         __atomic_work_item_fence(flags, __memory_order_acquire, scope);
	s_waitcnt lgkmcnt(0)
	v_add_lshl_u32 v2, v5, v6, 4
	s_movk_i32 s6, 0x1180
	v_add_co_u32_e32 v3, vcc, s6, v0
	v_addc_co_u32_e32 v4, vcc, 0, v1, vcc
;     if(thread < 48)
	v_cmp_gt_u32_e32 vcc, 48, v6
;     TR0 = (*R0).x + (*R2).x + (*R4).x;
	v_add_f64 v[37:38], v[9:10], v[17:18]
;     TI0 = (*R0).y + (*R2).y + (*R4).y;
	v_add_f64 v[39:40], v[11:12], v[19:20]
;     TI3 = ((*R1).y - C3QA * ((*R3).y + (*R5).y)) - C3QB * ((*R3).x - (*R5).x);
	v_add_f64 v[33:34], v[23:24], v[31:32]
;     TR3 = ((*R1).x - C3QA * ((*R3).x + (*R5).x)) + C3QB * ((*R3).y - (*R5).y);
	v_add_f64 v[35:36], v[21:22], v[29:30]
;     TR1 = (*R1).x + (*R3).x + (*R5).x;
	v_add_f64 v[41:42], v[13:14], v[21:22]
;     TI1 = (*R1).y + (*R3).y + (*R5).y;
	v_add_f64 v[43:44], v[15:16], v[23:24]
;     TR3 = ((*R1).x - C3QA * ((*R3).x + (*R5).x)) + C3QB * ((*R3).y - (*R5).y);
	v_add_f64 v[23:24], v[23:24], -v[31:32]
;     TI3 = ((*R1).y - C3QA * ((*R3).y + (*R5).y)) - C3QB * ((*R3).x - (*R5).x);
	v_add_f64 v[21:22], v[21:22], -v[29:30]
	v_fma_f64 v[15:16], v[33:34], -0.5, v[15:16]
;     TR3 = ((*R1).x - C3QA * ((*R3).x + (*R5).x)) + C3QB * ((*R3).y - (*R5).y);
	v_fma_f64 v[13:14], v[35:36], -0.5, v[13:14]
;     TR2 = ((*R0).x - C3QA * ((*R2).x + (*R4).x)) + C3QB * ((*R2).y - (*R4).y);
	v_add_f64 v[33:34], v[17:18], v[25:26]
	v_add_f64 v[35:36], v[19:20], -v[27:28]
;     TI2 = ((*R0).y - C3QA * ((*R2).y + (*R4).y)) - C3QB * ((*R2).x - (*R4).x);
	v_add_f64 v[19:20], v[19:20], v[27:28]
	v_add_f64 v[17:18], v[17:18], -v[25:26]
;     TR0 = (*R0).x + (*R2).x + (*R4).x;
	v_add_f64 v[25:26], v[37:38], v[25:26]
;     TI0 = (*R0).y + (*R2).y + (*R4).y;
	v_add_f64 v[27:28], v[39:40], v[27:28]
;     TI3 = ((*R1).y - C3QA * ((*R3).y + (*R5).y)) - C3QB * ((*R3).x - (*R5).x);
	v_fma_f64 v[37:38], v[21:22], s[4:5], v[15:16]
;     TR3 = ((*R1).x - C3QA * ((*R3).x + (*R5).x)) + C3QB * ((*R3).y - (*R5).y);
	v_fma_f64 v[39:40], v[23:24], s[2:3], v[13:14]
;     TR5 = ((*R1).x - C3QA * ((*R3).x + (*R5).x)) - C3QB * ((*R3).y - (*R5).y);
	v_fma_f64 v[13:14], v[23:24], s[4:5], v[13:14]
;     TI5 = ((*R1).y - C3QA * ((*R3).y + (*R5).y)) + C3QB * ((*R3).x - (*R5).x);
	v_fma_f64 v[15:16], v[21:22], s[2:3], v[15:16]
;     TR2 = ((*R0).x - C3QA * ((*R2).x + (*R4).x)) + C3QB * ((*R2).y - (*R4).y);
	v_fma_f64 v[21:22], v[33:34], -0.5, v[9:10]
;     TI2 = ((*R0).y - C3QA * ((*R2).y + (*R4).y)) - C3QB * ((*R2).x - (*R4).x);
	v_fma_f64 v[19:20], v[19:20], -0.5, v[11:12]
;     TR1 = (*R1).x + (*R3).x + (*R5).x;
	v_add_f64 v[29:30], v[41:42], v[29:30]
;     TI1 = (*R1).y + (*R3).y + (*R5).y;
	v_add_f64 v[31:32], v[43:44], v[31:32]
;     (*R1).x = TR2 + (C3QA * TR3 + C3QB * TI3);
	v_mul_f64 v[23:24], v[37:38], s[2:3]
;     (*R1).y = TI2 + (-C3QB * TR3 + C3QA * TI3);
	v_mul_f64 v[33:34], v[39:40], s[4:5]
;     (*R2).x = TR4 + (-C3QA * TR5 + C3QB * TI5);
	v_mul_f64 v[41:42], v[13:14], -0.5
;     (*R2).y = TI4 + (-C3QB * TR5 - C3QA * TI5);
	v_mul_f64 v[43:44], v[15:16], -0.5
;     TR2 = ((*R0).x - C3QA * ((*R2).x + (*R4).x)) + C3QB * ((*R2).y - (*R4).y);
	v_fma_f64 v[45:46], v[35:36], s[2:3], v[21:22]
;     TI2 = ((*R0).y - C3QA * ((*R2).y + (*R4).y)) - C3QB * ((*R2).x - (*R4).x);
	v_fma_f64 v[47:48], v[17:18], s[4:5], v[19:20]
;     TR4 = ((*R0).x - C3QA * ((*R2).x + (*R4).x)) - C3QB * ((*R2).y - (*R4).y);
	v_fma_f64 v[35:36], v[35:36], s[4:5], v[21:22]
;     (*R0).x = TR0 + TR1;
	v_add_f64 v[9:10], v[25:26], v[29:30]
;     (*R1).x = TR2 + (C3QA * TR3 + C3QB * TI3);
	v_fma_f64 v[23:24], v[39:40], 0.5, v[23:24]
;     (*R1).y = TI2 + (-C3QB * TR3 + C3QA * TI3);
	v_fma_f64 v[33:34], v[37:38], 0.5, v[33:34]
;     TI4 = ((*R0).y - C3QA * ((*R2).y + (*R4).y)) + C3QB * ((*R2).x - (*R4).x);
	v_fma_f64 v[37:38], v[17:18], s[2:3], v[19:20]
;     (*R2).x = TR4 + (-C3QA * TR5 + C3QB * TI5);
	v_fma_f64 v[39:40], v[15:16], s[2:3], v[41:42]
;     (*R2).y = TI4 + (-C3QB * TR5 - C3QA * TI5);
	v_fma_f64 v[41:42], v[13:14], s[4:5], v[43:44]
;     (*R0).y = TI0 + TI1;
	v_add_f64 v[11:12], v[27:28], v[31:32]
;     (*R3).x = TR0 - TR1;
	v_add_f64 v[13:14], v[25:26], -v[29:30]
;     (*R3).y = TI0 - TI1;
	v_add_f64 v[15:16], v[27:28], -v[31:32]
;     (*R1).x = TR2 + (C3QA * TR3 + C3QB * TI3);
	v_add_f64 v[17:18], v[45:46], v[23:24]
;     (*R1).y = TI2 + (-C3QB * TR3 + C3QA * TI3);
	v_add_f64 v[19:20], v[47:48], v[33:34]
;     (*R4).x = TR2 - (C3QA * TR3 + C3QB * TI3);
	v_add_f64 v[21:22], v[45:46], -v[23:24]
;     (*R2).x = TR4 + (-C3QA * TR5 + C3QB * TI5);
	v_add_f64 v[25:26], v[35:36], v[39:40]
;     (*R2).y = TI4 + (-C3QB * TR5 - C3QA * TI5);
	v_add_f64 v[27:28], v[37:38], v[41:42]
;     (*R4).y = TI2 - (-C3QB * TR3 + C3QA * TI3);
	v_add_f64 v[23:24], v[47:48], -v[33:34]
;     (*R5).x = TR4 - (-C3QA * TR5 + C3QB * TI5);
	v_add_f64 v[29:30], v[35:36], -v[39:40]
;     (*R5).y = TI4 - (-C3QB * TR5 - C3QA * TI5);
	v_add_f64 v[31:32], v[37:38], -v[41:42]
;                 data = x.data;
	ds_write_b128 v49, v[9:12]
	ds_write_b128 v49, v[13:16] offset:48
	ds_write_b128 v49, v[17:20] offset:16
	ds_write_b128 v49, v[25:28] offset:32
	ds_write_b128 v49, v[21:24] offset:64
	ds_write_b128 v49, v[29:32] offset:80
;         __atomic_work_item_fence(flags, __memory_order_release, scope);
	s_waitcnt lgkmcnt(0)
;         __builtin_amdgcn_s_barrier();
	s_barrier
;         __atomic_work_item_fence(flags, __memory_order_acquire, scope);
	s_waitcnt lgkmcnt(0)
;         HIP_vector_type& operator=(const HIP_vector_type&) = default;
	global_load_dwordx4 v[13:16], v53, s[12:13] offset:128
	global_load_dwordx4 v[17:20], v53, s[12:13] offset:112
	global_load_dwordx4 v[41:44], v53, s[12:13] offset:96
	global_load_dwordx4 v[49:52], v53, s[12:13] offset:80
	global_load_dwordx4 v[25:28], v53, s[12:13] offset:160
	global_load_dwordx4 v[21:24], v53, s[12:13] offset:144
	ds_read_b128 v[9:12], v2
	ds_read_b128 v[57:60], v2 offset:768
	ds_read_b128 v[53:56], v2 offset:1536
	ds_read_b128 v[33:36], v2 offset:2304
	ds_read_b128 v[29:32], v2 offset:3072
	ds_read_b128 v[37:40], v2 offset:3840
	ds_read_b128 v[45:48], v2 offset:4608
;         __atomic_work_item_fence(flags, __memory_order_release, scope);
	s_waitcnt vmcnt(0) lgkmcnt(0)
;         __builtin_amdgcn_s_barrier();
	s_barrier
;         __atomic_work_item_fence(flags, __memory_order_acquire, scope);
	s_waitcnt lgkmcnt(0)
	s_and_saveexec_b64 s[2:3], vcc
	s_cbranch_execz BB2_9
;     t.x  = W.x * R[2].x - W.y * R[2].y; /* stockham-generator:102 */
	v_mul_f64 v[63:64], v[55:56], v[43:44]
;     t.y  = W.y * R[2].x + W.x * R[2].y; /* stockham-generator:103 */
	v_mul_f64 v[55:56], v[55:56], v[41:42]
;     t.x  = W.x * R[1].x - W.y * R[1].y; /* stockham-generator:102 */
	v_mul_f64 v[61:62], v[59:60], v[51:52]
;     t.y  = W.y * R[1].x + W.x * R[1].y; /* stockham-generator:103 */
	v_mul_f64 v[59:60], v[59:60], v[49:50]
;     t.x  = W.x * R[6].x - W.y * R[6].y; /* stockham-generator:102 */
	v_mul_f64 v[65:66], v[47:48], v[27:28]
;     t.y  = W.y * R[6].x + W.x * R[6].y; /* stockham-generator:103 */
	v_mul_f64 v[47:48], v[47:48], v[25:26]
	s_mov_b32 s5, 0x3fac98ee
	s_mov_b32 s4, 0x36b3c0b5
;     t.x  = W.x * R[2].x - W.y * R[2].y; /* stockham-generator:102 */
	v_fma_f64 v[41:42], v[53:54], v[41:42], -v[63:64]
;     t.y  = W.y * R[2].x + W.x * R[2].y; /* stockham-generator:103 */
	v_fma_f64 v[43:44], v[53:54], v[43:44], v[55:56]
;     t.x  = W.x * R[5].x - W.y * R[5].y; /* stockham-generator:102 */
	v_mul_f64 v[53:54], v[39:40], v[23:24]
;     t.y  = W.y * R[5].x + W.x * R[5].y; /* stockham-generator:103 */
	v_mul_f64 v[39:40], v[39:40], v[21:22]
;     t.x  = W.x * R[3].x - W.y * R[3].y; /* stockham-generator:102 */
	v_mul_f64 v[55:56], v[35:36], v[19:20]
;     t.y  = W.y * R[3].x + W.x * R[3].y; /* stockham-generator:103 */
	v_mul_f64 v[35:36], v[35:36], v[17:18]
;     t.x  = W.x * R[1].x - W.y * R[1].y; /* stockham-generator:102 */
	v_fma_f64 v[49:50], v[57:58], v[49:50], -v[61:62]
;     t.y  = W.y * R[1].x + W.x * R[1].y; /* stockham-generator:103 */
	v_fma_f64 v[51:52], v[57:58], v[51:52], v[59:60]
;     t.x  = W.x * R[4].x - W.y * R[4].y; /* stockham-generator:102 */
	v_mul_f64 v[57:58], v[31:32], v[15:16]
;     t.y  = W.y * R[4].x + W.x * R[4].y; /* stockham-generator:103 */
	v_mul_f64 v[31:32], v[31:32], v[13:14]
;     t.x  = W.x * R[6].x - W.y * R[6].y; /* stockham-generator:102 */
	v_fma_f64 v[25:26], v[45:46], v[25:26], -v[65:66]
;     t.x  = W.x * R[5].x - W.y * R[5].y; /* stockham-generator:102 */
	v_fma_f64 v[21:22], v[37:38], v[21:22], -v[53:54]
;     t.y  = W.y * R[6].x + W.x * R[6].y; /* stockham-generator:103 */
	v_fma_f64 v[27:28], v[45:46], v[27:28], v[47:48]
;     t.y  = W.y * R[5].x + W.x * R[5].y; /* stockham-generator:103 */
	v_fma_f64 v[23:24], v[37:38], v[23:24], v[39:40]
;     t.y  = W.y * R[3].x + W.x * R[3].y; /* stockham-generator:103 */
	v_fma_f64 v[19:20], v[33:34], v[19:20], v[35:36]
;     t.x  = W.x * R[3].x - W.y * R[3].y; /* stockham-generator:102 */
	v_fma_f64 v[17:18], v[33:34], v[17:18], -v[55:56]
;     t.x  = W.x * R[4].x - W.y * R[4].y; /* stockham-generator:102 */
	v_fma_f64 v[13:14], v[29:30], v[13:14], -v[57:58]
;     t.y  = W.y * R[4].x + W.x * R[4].y; /* stockham-generator:103 */
	v_fma_f64 v[15:16], v[29:30], v[15:16], v[31:32]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[29:30], v[49:50], v[25:26]
	v_add_f64 v[31:32], v[41:42], v[21:22]
	v_add_f64 v[33:34], v[51:52], v[27:28]
	v_add_f64 v[35:36], v[43:44], v[23:24]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[21:22], v[41:42], -v[21:22]
	v_add_f64 v[25:26], v[49:50], -v[25:26]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[37:38], v[17:18], v[13:14]
	v_add_f64 v[45:46], v[19:20], v[15:16]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[13:14], v[13:14], -v[17:18]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[39:40], v[31:32], v[29:30]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[17:18], v[43:44], -v[23:24]
	v_add_f64 v[15:16], v[15:16], -v[19:20]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[47:48], v[35:36], v[33:34]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[19:20], v[31:32], -v[29:30]
	v_add_f64 v[23:24], v[29:30], -v[37:38]
	v_add_f64 v[29:30], v[37:38], -v[31:32]
	v_add_f64 v[27:28], v[51:52], -v[27:28]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[39:40], v[37:38], v[39:40]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[37:38], v[35:36], -v[33:34]
	v_add_f64 v[35:36], v[45:46], -v[35:36]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[31:32], v[13:14], v[21:22]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[33:34], v[33:34], -v[45:46]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[41:42], v[15:16], v[17:18]
;             data *= x.data;
	v_mul_f64 v[29:30], v[29:30], s[4:5]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[43:44], v[13:14], -v[21:22]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[47:48], v[45:46], v[47:48]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[13:14], v[25:26], -v[13:14]
;             data *= x.data;
	v_mul_f64 v[35:36], v[35:36], s[4:5]
	s_mov_b32 s5, 0x3fe948f6
	s_mov_b32 s4, 0x37e14327
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[21:22], v[21:22], -v[25:26]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[25:26], v[31:32], v[25:26]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[31:32], v[15:16], -v[17:18]
	v_add_f64 v[15:16], v[27:28], -v[15:16]
	v_add_f64 v[17:18], v[17:18], -v[27:28]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[27:28], v[41:42], v[27:28]
;             data *= x.data;
	v_mul_f64 v[41:42], v[23:24], s[4:5]
	v_mul_f64 v[45:46], v[33:34], s[4:5]
	s_mov_b32 s7, 0x3fe77f67
	s_mov_b32 s6, 0x5476071b
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_fma_f64 v[49:50], v[19:20], s[6:7], -v[29:30]
	v_fma_f64 v[51:52], v[37:38], s[6:7], -v[35:36]
	s_mov_b32 s7, 0xbfe77f67
	s_mov_b32 s9, 0xbfe11646
	s_mov_b32 s8, 0xe976ee23
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[9:10], v[9:10], v[39:40]
	v_add_f64 v[11:12], v[11:12], v[47:48]
;             data *= x.data;
	v_mul_f64 v[43:44], v[43:44], s[8:9]
	v_mul_f64 v[31:32], v[31:32], s[8:9]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_fma_f64 v[19:20], v[19:20], s[6:7], -v[41:42]
	v_fma_f64 v[37:38], v[37:38], s[6:7], -v[45:46]
	s_mov_b32 s7, 0x3febfeb5
	s_mov_b32 s6, 0x429ad128
;             data *= x.data;
	v_mul_f64 v[45:46], v[17:18], s[6:7]
	v_mul_f64 v[53:54], v[21:22], s[6:7]
	s_mov_b32 s9, 0x3fd5d0dc
	s_mov_b32 s8, 0xb247c609
	s_mov_b32 s11, 0xbff2aaaa
	s_mov_b32 s10, 0xaaaaaaaa
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_fma_f64 v[39:40], v[39:40], s[10:11], v[9:10]
	v_fma_f64 v[47:48], v[47:48], s[10:11], v[11:12]
	v_fma_f64 v[23:24], v[23:24], s[4:5], v[29:30]
	v_fma_f64 v[29:30], v[33:34], s[4:5], v[35:36]
	v_fma_f64 v[41:42], v[13:14], s[8:9], v[43:44]
	v_fma_f64 v[55:56], v[15:16], s[8:9], v[31:32]
	s_mov_b32 s9, 0xbfd5d0dc
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_fma_f64 v[15:16], v[15:16], s[8:9], -v[45:46]
	v_fma_f64 v[13:14], v[13:14], s[8:9], -v[53:54]
	v_fma_f64 v[17:18], v[17:18], s[6:7], -v[31:32]
	v_fma_f64 v[21:22], v[21:22], s[6:7], -v[43:44]
	s_mov_b32 s9, 0x3fdc38aa
	s_mov_b32 s8, 0x37c3f68c
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_fma_f64 v[35:36], v[25:26], s[8:9], v[41:42]
	v_add_f64 v[31:32], v[23:24], v[39:40]
	v_add_f64 v[29:30], v[29:30], v[47:48]
	v_fma_f64 v[33:34], v[27:28], s[8:9], v[55:56]
	v_add_f64 v[19:20], v[19:20], v[39:40]
	v_add_f64 v[37:38], v[37:38], v[47:48]
	v_fma_f64 v[45:46], v[27:28], s[8:9], v[15:16]
	v_fma_f64 v[53:54], v[25:26], s[8:9], v[13:14]
	v_fma_f64 v[43:44], v[27:28], s[8:9], v[17:18]
	v_add_f64 v[41:42], v[51:52], v[47:48]
	v_fma_f64 v[47:48], v[25:26], s[8:9], v[21:22]
	v_add_f64 v[39:40], v[49:50], v[39:40]
;     (*R1).x = p7.x + q6.y;
	v_add_f64 v[25:26], v[33:34], v[31:32]
;     (*R1).y = p7.y - q6.x;
	v_add_f64 v[27:28], v[29:30], -v[35:36]
;     (*R5).x = p9.x - q8.y;
	v_add_f64 v[13:14], v[19:20], -v[45:46]
;     (*R2).x = p9.x + q8.y;
	v_add_f64 v[17:18], v[45:46], v[19:20]
;     (*R2).y = p9.y - q8.x;
	v_add_f64 v[19:20], v[37:38], -v[53:54]
;     (*R6).x = p7.x - q6.y;
	v_add_f64 v[21:22], v[31:32], -v[33:34]
;     (*R6).y = p7.y + q6.x;
	v_add_f64 v[23:24], v[35:36], v[29:30]
;     (*R3).x = p8.x - q7.y;
	v_add_f64 v[33:34], v[39:40], -v[43:44]
;     (*R3).y = p8.y + q7.x;
	v_add_f64 v[35:36], v[47:48], v[41:42]
;     (*R4).x = p8.x + q7.y;
	v_add_f64 v[29:30], v[43:44], v[39:40]
;     (*R4).y = p8.y - q7.x;
	v_add_f64 v[31:32], v[41:42], -v[47:48]
;     (*R5).y = p9.y + q8.x;
	v_add_f64 v[15:16], v[53:54], v[37:38]
;         lds[offset_lds + (thread / 6) * 42 + thread % 6 + 0]  = R[0]; /* stockham-generator:129 */
	v_mov_b32_e32 v37, 42
	v_mul_u32_u24_sdwa v7, v7, v37 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
	v_or_b32_e32 v8, v5, v8
	v_add_lshl_u32 v7, v8, v7, 4
;                 data = x.data;
	ds_write_b128 v7, v[9:12]
	ds_write_b128 v7, v[25:28] offset:96
	ds_write_b128 v7, v[17:20] offset:192
	ds_write_b128 v7, v[33:36] offset:288
	ds_write_b128 v7, v[29:32] offset:384
	ds_write_b128 v7, v[13:16] offset:480
	ds_write_b128 v7, v[21:24] offset:576

<BB2_9>:
	s_or_b64 exec, exec, s[2:3]
;     W    = twiddles[41 + 7 * (thread % 42)]; /* stockham-generator:101 */
	v_and_b32_e32 v7, s0, v6
	v_lshrrev_b16_e32 v8, 1, v7
	v_mul_u32_u24_e32 v8, 0xc30d, v8
	v_lshrrev_b32_e32 v8, 20, v8
	v_mul_lo_u16_e32 v8, 42, v8
	v_sub_u16_e32 v7, v7, v8
	v_mul_u32_u24_e32 v8, 7, v7
	v_lshlrev_b32_e32 v8, 4, v8
;         __atomic_work_item_fence(flags, __memory_order_release, scope);
	s_waitcnt lgkmcnt(0)
;         __builtin_amdgcn_s_barrier();
	s_barrier
;         __atomic_work_item_fence(flags, __memory_order_acquire, scope);
	s_waitcnt lgkmcnt(0)
;         HIP_vector_type& operator=(const HIP_vector_type&) = default;
	global_load_dwordx4 v[28:31], v8, s[12:13] offset:704
	global_load_dwordx4 v[44:47], v8, s[12:13] offset:688
	global_load_dwordx4 v[48:51], v8, s[12:13] offset:672
	global_load_dwordx4 v[52:55], v8, s[12:13] offset:656
	global_load_dwordx4 v[12:15], v8, s[12:13] offset:752
	global_load_dwordx4 v[32:35], v8, s[12:13] offset:736
	global_load_dwordx4 v[16:19], v8, s[12:13] offset:720
	ds_read_b128 v[8:11], v2
	ds_read_b128 v[64:67], v2 offset:672
	ds_read_b128 v[60:63], v2 offset:1344
	ds_read_b128 v[56:59], v2 offset:2016
	ds_read_b128 v[40:43], v2 offset:2688
	ds_read_b128 v[20:23], v2 offset:3360
	ds_read_b128 v[36:39], v2 offset:4032
	ds_read_b128 v[24:27], v2 offset:4704
;     if(thread < 42)
	v_cmp_gt_u32_e32 vcc, 42, v6
;         __atomic_work_item_fence(flags, __memory_order_release, scope);
	s_waitcnt vmcnt(0) lgkmcnt(0)
;         __builtin_amdgcn_s_barrier();
	s_barrier
;         __atomic_work_item_fence(flags, __memory_order_acquire, scope);
	s_waitcnt lgkmcnt(0)
	s_and_saveexec_b64 s[0:1], vcc
	s_cbranch_execz BB2_11
;     t.x  = W.x * R[3].x - W.y * R[3].y; /* stockham-generator:102 */
	v_mul_f64 v[72:73], v[58:59], v[46:47]
;     t.y  = W.y * R[3].x + W.x * R[3].y; /* stockham-generator:103 */
	v_mul_f64 v[58:59], v[58:59], v[44:45]
;     t.x  = W.x * R[4].x - W.y * R[4].y; /* stockham-generator:102 */
	v_mul_f64 v[74:75], v[42:43], v[30:31]
;     t.y  = W.y * R[4].x + W.x * R[4].y; /* stockham-generator:103 */
	v_mul_f64 v[42:43], v[42:43], v[28:29]
;     t.x  = W.x * R[1].x - W.y * R[1].y; /* stockham-generator:102 */
	v_mul_f64 v[68:69], v[66:67], v[54:55]
;     t.y  = W.y * R[1].x + W.x * R[1].y; /* stockham-generator:103 */
	v_mul_f64 v[66:67], v[66:67], v[52:53]
;     t.x  = W.x * R[2].x - W.y * R[2].y; /* stockham-generator:102 */
	v_mul_f64 v[70:71], v[62:63], v[50:51]
;     t.y  = W.y * R[2].x + W.x * R[2].y; /* stockham-generator:103 */
	v_mul_f64 v[62:63], v[62:63], v[48:49]
;     t.x  = W.x * R[3].x - W.y * R[3].y; /* stockham-generator:102 */
	v_fma_f64 v[44:45], v[56:57], v[44:45], -v[72:73]
;     t.y  = W.y * R[3].x + W.x * R[3].y; /* stockham-generator:103 */
	v_fma_f64 v[46:47], v[56:57], v[46:47], v[58:59]
;     t.x  = W.x * R[4].x - W.y * R[4].y; /* stockham-generator:102 */
	v_fma_f64 v[28:29], v[40:41], v[28:29], -v[74:75]
;     t.y  = W.y * R[4].x + W.x * R[4].y; /* stockham-generator:103 */
	v_fma_f64 v[30:31], v[40:41], v[30:31], v[42:43]
;     t.y  = W.y * R[6].x + W.x * R[6].y; /* stockham-generator:103 */
	v_mul_f64 v[56:57], v[38:39], v[32:33]
;     t.x  = W.x * R[6].x - W.y * R[6].y; /* stockham-generator:102 */
	v_mul_f64 v[38:39], v[38:39], v[34:35]
;     t.x  = W.x * R[5].x - W.y * R[5].y; /* stockham-generator:102 */
	v_mul_f64 v[40:41], v[22:23], v[18:19]
;     t.y  = W.y * R[5].x + W.x * R[5].y; /* stockham-generator:103 */
	v_mul_f64 v[22:23], v[22:23], v[16:17]
;     t.x  = W.x * R[7].x - W.y * R[7].y; /* stockham-generator:102 */
	v_mul_f64 v[42:43], v[26:27], v[14:15]
;     t.y  = W.y * R[7].x + W.x * R[7].y; /* stockham-generator:103 */
	v_mul_f64 v[26:27], v[26:27], v[12:13]
;     t.x  = W.x * R[1].x - W.y * R[1].y; /* stockham-generator:102 */
	v_fma_f64 v[52:53], v[64:65], v[52:53], -v[68:69]
;     t.y  = W.y * R[1].x + W.x * R[1].y; /* stockham-generator:103 */
	v_fma_f64 v[54:55], v[64:65], v[54:55], v[66:67]
;     t.x  = W.x * R[2].x - W.y * R[2].y; /* stockham-generator:102 */
	v_fma_f64 v[48:49], v[60:61], v[48:49], -v[70:71]
;     t.y  = W.y * R[2].x + W.x * R[2].y; /* stockham-generator:103 */
	v_fma_f64 v[50:51], v[60:61], v[50:51], v[62:63]
;     t.x  = W.x * R[5].x - W.y * R[5].y; /* stockham-generator:102 */
	v_fma_f64 v[16:17], v[20:21], v[16:17], -v[40:41]
;     t.y  = W.y * R[5].x + W.x * R[5].y; /* stockham-generator:103 */
	v_fma_f64 v[18:19], v[20:21], v[18:19], v[22:23]
;     t.x  = W.x * R[7].x - W.y * R[7].y; /* stockham-generator:102 */
	v_fma_f64 v[12:13], v[24:25], v[12:13], -v[42:43]
;     t.y  = W.y * R[7].x + W.x * R[7].y; /* stockham-generator:103 */
	v_fma_f64 v[14:15], v[24:25], v[14:15], v[26:27]
;     t.y  = W.y * R[6].x + W.x * R[6].y; /* stockham-generator:103 */
	v_fma_f64 v[34:35], v[36:37], v[34:35], v[56:57]
;     t.x  = W.x * R[6].x - W.y * R[6].y; /* stockham-generator:102 */
	v_fma_f64 v[32:33], v[36:37], v[32:33], -v[38:39]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[28:29], v[8:9], -v[28:29]
	v_add_f64 v[30:31], v[10:11], -v[30:31]
	v_add_f64 v[16:17], v[52:53], -v[16:17]
	v_add_f64 v[18:19], v[54:55], -v[18:19]
	v_add_f64 v[12:13], v[44:45], -v[12:13]
	v_add_f64 v[14:15], v[46:47], -v[14:15]
	v_add_f64 v[20:21], v[50:51], -v[34:35]
	v_add_f64 v[22:23], v[48:49], -v[32:33]
	v_fma_f64 v[8:9], v[8:9], 2.0, -v[28:29]
	v_fma_f64 v[10:11], v[10:11], 2.0, -v[30:31]
	v_fma_f64 v[24:25], v[52:53], 2.0, -v[16:17]
	v_fma_f64 v[26:27], v[54:55], 2.0, -v[18:19]
	v_fma_f64 v[32:33], v[44:45], 2.0, -v[12:13]
	v_fma_f64 v[34:35], v[46:47], 2.0, -v[14:15]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[36:37], v[28:29], -v[20:21]
	v_add_f64 v[38:39], v[30:31], v[22:23]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_fma_f64 v[22:23], v[48:49], 2.0, -v[22:23]
	v_fma_f64 v[20:21], v[50:51], 2.0, -v[20:21]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[40:41], v[16:17], -v[14:15]
	v_add_f64 v[42:43], v[18:19], v[12:13]
	s_mov_b32 s2, 0x667f3bcd
	s_mov_b32 s3, 0xbfe6a09e
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_fma_f64 v[28:29], v[28:29], 2.0, -v[36:37]
	v_fma_f64 v[30:31], v[30:31], 2.0, -v[38:39]
	v_add_f64 v[44:45], v[8:9], -v[22:23]
	v_add_f64 v[46:47], v[10:11], -v[20:21]
	v_add_f64 v[20:21], v[24:25], -v[32:33]
	v_add_f64 v[22:23], v[26:27], -v[34:35]
	v_fma_f64 v[14:15], v[16:17], 2.0, -v[40:41]
	v_fma_f64 v[12:13], v[18:19], 2.0, -v[42:43]
	s_mov_b32 s5, 0x3fe6a09e
	s_mov_b32 s4, s2
	v_fma_f64 v[32:33], v[8:9], 2.0, -v[44:45]
	v_fma_f64 v[34:35], v[10:11], 2.0, -v[46:47]
	v_fma_f64 v[8:9], v[24:25], 2.0, -v[20:21]
	v_fma_f64 v[10:11], v[26:27], 2.0, -v[22:23]
	v_fma_f64 v[16:17], v[14:15], s[2:3], v[28:29]
	v_fma_f64 v[18:19], v[12:13], s[2:3], v[30:31]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_fma_f64 v[24:25], v[40:41], s[4:5], v[36:37]
	v_fma_f64 v[26:27], v[42:43], s[4:5], v[38:39]
	v_add_lshl_u32 v5, v5, v7, 4
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[8:9], v[32:33], -v[8:9]
	v_add_f64 v[10:11], v[34:35], -v[10:11]
	v_fma_f64 v[12:13], v[12:13], s[2:3], v[16:17]
	v_fma_f64 v[14:15], v[14:15], s[4:5], v[18:19]
; COMPLEX_ADD_OP_OVERLOAD(hipDoubleComplex)
	v_add_f64 v[16:17], v[44:45], -v[22:23]
	v_add_f64 v[18:19], v[46:47], v[20:21]
; COMPLEX_SUB_OP_OVERLOAD(hipDoubleComplex)
	v_fma_f64 v[20:21], v[42:43], s[2:3], v[24:25]
	v_fma_f64 v[22:23], v[40:41], s[4:5], v[26:27]
	v_fma_f64 v[24:25], v[32:33], 2.0, -v[8:9]
	v_fma_f64 v[26:27], v[34:35], 2.0, -v[10:11]
	v_fma_f64 v[28:29], v[28:29], 2.0, -v[12:13]
	v_fma_f64 v[30:31], v[30:31], 2.0, -v[14:15]
	v_fma_f64 v[32:33], v[44:45], 2.0, -v[16:17]
	v_fma_f64 v[34:35], v[46:47], 2.0, -v[18:19]
	v_fma_f64 v[36:37], v[36:37], 2.0, -v[20:21]
	v_fma_f64 v[38:39], v[38:39], 2.0, -v[22:23]
;                 data = x.data;
	ds_write_b128 v5, v[24:27]
	ds_write_b128 v5, v[28:31] offset:672
	ds_write_b128 v5, v[32:35] offset:1344
	ds_write_b128 v5, v[36:39] offset:2016
	ds_write_b128 v5, v[8:11] offset:2688
	ds_write_b128 v5, v[12:15] offset:3360
	ds_write_b128 v5, v[16:19] offset:4032
	ds_write_b128 v5, v[20:23] offset:4704

<BB2_11>:
	s_or_b64 exec, exec, s[0:1]
;         __atomic_work_item_fence(flags, __memory_order_release, scope);
	s_waitcnt lgkmcnt(0)
;         __builtin_amdgcn_s_barrier();
	s_barrier
;         __atomic_work_item_fence(flags, __memory_order_acquire, scope);
	s_waitcnt lgkmcnt(0)
;         HIP_vector_type& operator=(const HIP_vector_type&) = default;
	ds_read_b128 v[5:8], v2
	ds_read_b128 v[9:12], v2 offset:896
;                 data = x.data;
	s_waitcnt lgkmcnt(1)
	global_store_dwordx4 v[0:1], v[5:8], off
;         HIP_vector_type& operator=(const HIP_vector_type&) = default;
	ds_read_b128 v[5:8], v2 offset:1792
	ds_read_b128 v[13:16], v2 offset:2688
;                 data = x.data;
	s_waitcnt lgkmcnt(2)
	global_store_dwordx4 v[0:1], v[9:12], off offset:896
;         HIP_vector_type& operator=(const HIP_vector_type&) = default;
	ds_read_b128 v[9:12], v2 offset:3584
	ds_read_b128 v[17:20], v2 offset:4480
;                 data = x.data;
	s_waitcnt lgkmcnt(3)
	global_store_dwordx4 v[0:1], v[5:8], off offset:1792
	s_waitcnt lgkmcnt(2)
	global_store_dwordx4 v[0:1], v[13:16], off offset:2688
	s_waitcnt lgkmcnt(1)
	global_store_dwordx4 v[0:1], v[9:12], off offset:3584
	s_waitcnt lgkmcnt(0)
	global_store_dwordx4 v[3:4], v[17:20], off
; }
	s_endpgm
