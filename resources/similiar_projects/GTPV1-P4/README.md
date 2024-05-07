# GTPV1-P4
This P4 program performs network telemetry in a GTP network.

The folder/files contain:
* `Include`: contains the P4 program files. The P4 file `main.p4` defines the "total pipeline" and the files contained in `Include` folder specifies:  headers, parser, tables, etc.
* `Command files`: These files contain a set of flow rules for configuring a P4 switch loaded with GTPV1-P4 pipeline.
* `Parsing_INT_pkt`: is a python script for parsing a report packet and send the telemetry infortaions, contained in the packet, to Grafana.
* `Simple_network_topology`: is a python script for creating a mininet network.
* `Write_entries_scan`: is a python script for creating flow rules.

## Steps to run GTPV1-P4 on Mininet

1. Install behavioral-model using the following steps: [BMv2][BMv2].
2. Copy the file `Simple_network_topology` in the folder `behavioral-model/mininet`.
3. Copy the file `main.json` to the folder `behavioral-model`

To run the mininet topology populated with [BMv2][BMv2] switches that have a GTP pipeline, run the following command in the mininet folder of behavorial-model:

    sudo python Simple_network_topology.py --behavioral-exe targets/simple_switch/simple_switch --json main.json --num-host 4

After running this command, you get a network topology formed by 3 bmv2 switches, `A,B,C`, connected in series. In the network are 4 hosts, `h1,h2,h3,h4`, where `h1,h2` are attached to `A`, `h3` is attached to `B` and `h4` is attached to `C`. 

To configure/inspect the flow rules in each switch by hand, you can access the switch via `Simple_switch_CLI` in the folder `targets/simple_switch/simple_switch`, provided by behavioral model, e.g., 

    ./Simple_switch_CLI --thrift-port portNumber
    
Once you accessed the switch via CLI you are able to configure the flow rules in each table via the commands provided by the CLI, e.g. `table_add`.

To load a set of flow rules in a switch from a file you can use:

    ./Simple_switch_CLI --thrift-port portNumber < .../Commands_s1.txt

The `Command files`, in this repository, are written taking into account:
* `h1 -> h4`, the switch `A` provides GTP encap, `B` provides GTP steering ,`C` provides GTP decap.
* `h2 -> h3`, the switch `A` provides GTP encap, `B` provides GTP decap
* the switch `A` send the postcard telemetry related to the flow `h1 -> h4`, identified as a flow 1, and `h2 -> h3` identified as a flow 2.
* the switch `B` send the postcard telemetry related to the flow `h1 -> h4`, identified as a flow 1.

    
## Steps to run GTPV1-P4 on a single switch

To run a single [BMv2][BMv2] switch with GTPV1-P4 pipeline:

    sudo ./simple_switch -i 0@<iface0> -i 1@<iface1> ../main.json 
    
To configure/inspect the flow rules in each switch by hand, you have to access the switch via `Simple_switch_CLI`, provided by behavioral model, e.g., 

    sudo Simple_switch_CLI --thrift-port portNumber
    
Once you accessed the switch via CLI you are able to configure the flow rules in each table via the commands provided by the CLI, e.g. `table_add`.

To load a set of flow rules in a switch from a file you can use:

    sudo Simple_switch_CLI --thrift-port portNumber < .../Commands_s1.txt
    
[GTP.v1]: https://en.wikipedia.org/wiki/GPRS_Tunnelling_Protocol
[BMv2]: https://github.com/p4lang/behavioral-model
