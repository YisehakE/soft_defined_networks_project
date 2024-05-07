#ifndef __CUSTOM_HEADERS__
#define __CUSTOM_HEADERS__

#ifndef __GTP_HEADERS__
#define __GTP_HEADERS__

#include "telemetry_report_headers.p4"

// GTP v1 header
header gtp_header_t {
    bit<3>  ver;             // Version
    bit<1>  pt;              // Protocol Type
    bit<1>  rsvd;            // Reserved
    bit<1>  e;               // Extension Header Flag
    bit<1>  s;               // Sequence Number Flag
    bit<1>  pn;              // N-PDU Number Flag
    bit<8>  msgtype;         // Message Type
    bit<16> total_len;       // Total Length
    bit<32> teid;            // Tunnel Endpoint Identifier
    //bit<16> sequence_number; // Sequence Number
    //bit<8>  npdu;           // N-PDU Number
    //bit<8>  next_ext_hdr;   // Next Extension Header (optional)
}


struct headers_t {
    // INT Report Encapsulation
    ethernet_t report_ethernet;
    ipv4_t report_ipv4;
    udp_t report_udp;
    // INT Report Headers
    report_fixed_header_t report_fixed_header;
    //local_report_t report_local;
    // Original packet's headers
    ethernet_t ethernet;
    ipv4_t ipv4;
    udp_t udp;
    //ipv4_t internal_ipv4;
    gtp_header_t gtp_header;
    ipv4_t internal_ipv4;
    udp_t internal_udp;
}

struct int_metadata_t {
    bit<1>  report;
}

struct local_metadata_t {
    int_metadata_t int_meta;
    bool compute_checksum;
}

#endif // __GTP_HEADERS__
#endif // __CUSTOM_HEADERS__