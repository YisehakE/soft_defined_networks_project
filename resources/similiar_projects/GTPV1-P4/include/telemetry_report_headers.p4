#ifndef __TELEMETRY_REPORT_HEADERS__
#define __TELEMETRY_REPORT_HEADERS__

const bit<3> NPROTO_ETHERNET = 0;

// Report Telemetry Headers
header report_fixed_header_t {
    bit<4>  ver;               // Version
    bit<4>  len;               // Length
    bit<3>  nproto;            // Network Protocol
    bit<6>  rep_md_bits;       // Report Metadata Bits
    bit<1>  d;                 // Debug
    bit<1>  q;                 // Queue
    bit<1>  f;                 // Flag
    bit<6>  rsvd;              // Reserved
    bit<6>  hw_id;             // Hardware ID
    bit<32> sw_id;             // Software ID
    bit<32> seq_no;            // Sequence Number
    bit<32> ingress_tstamp;    // Ingress Timestamp
    bit<32> engress_tstamp;    // Egress Timestamp
}
const bit<8> REPORT_FIXED_HEADER_LEN = 16;

#endif