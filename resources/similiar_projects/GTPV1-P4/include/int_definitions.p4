/* -*- P4_16 -*- */
#ifndef __INT_DEFINE__
#define __INT_DEFINE__

#include "defines.p4"

typedef bit<48> timestamp_t;
typedef bit<32> switch_id_t;

const bit<8>  INT_HEADER_LEN_WORD = 3;
const bit<16> INT_HEADER_SIZE = 8;
const bit<16> INT_SHIM_HEADER_SIZE = 4;

const bit<8>  CPU_MIRROR_SESSION_ID = 250;
const bit<32> REPORT_MIRROR_SESSION_ID = 500;
const bit<6> HW_ID = 1;
const bit<8> REPORT_HDR_TTL = 64;

//#ifdef TARGET_BMV2
// These definitions are from:
// https://github.com/jafingerhut/p4-guide/blob/master/v1model-special-ops/v1model-special-ops.p4

// These definitions are derived from the numerical values of the enum
// named "PktInstanceType" in the p4lang/behavioral-model source file
// targets/simple_switch/simple_switch.h
// https://github.com/p4lang/behavioral-model/blob/master/targets/simple_switch/simple_switch.h#L126-L134

const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_NORMAL        = 0;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_INGRESS_CLONE = 1;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_EGRESS_CLONE  = 2;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_COALESCED     = 3;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_RECIRC        = 4;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_REPLICATION   = 5;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_RESUBMIT      = 6;

#define IS_RESUBMITTED(smeta) (smeta.instance_type == BMV2_V1MODEL_INSTANCE_TYPE_RESUBMIT)
#define IS_RECIRCULATED(smeta)(smeta.instance_type == BMV2_V1MODEL_INSTANCE_TYPE_RECIRC)
#define IS_I2E_CLONE(smeta) (smeta.instance_type == BMV2_V1MODEL_INSTANCE_TYPE_INGRESS_CLONE)
#define IS_E2E_CLONE(smeta) (smeta.instance_type == BMV2_V1MODEL_INSTANCE_TYPE_EGRESS_CLONE)
#define IS_REPLICATED(smeta)(smeta.instance_type == BMV2_V1MODEL_INSTANCE_TYPE_REPLICATION)
//#endif // TARGET__BMV2

#endif
