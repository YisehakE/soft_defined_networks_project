package org.TelemetryBraine.app.pipeline;

import com.google.common.collect.ImmutableList;
import org.onosproject.core.CoreService;
import org.TelemetryBraine.app.postcard.postProgrammable;
import org.onosproject.net.behaviour.Pipeliner;
import org.onosproject.net.device.PortStatisticsDiscovery;
import org.onosproject.net.pi.model.DefaultPiPipeconf;
import org.onosproject.net.pi.model.PiPipeconf;
import org.onosproject.net.pi.model.PiPipeconfId;
import org.onosproject.net.pi.model.PiPipelineInterpreter;
import org.onosproject.net.pi.model.PiPipelineModel;
import org.onosproject.net.pi.service.PiPipeconfService;
import org.onosproject.p4runtime.model.P4InfoParser;
import org.onosproject.p4runtime.model.P4InfoParserException;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Deactivate;
import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ReferenceCardinality;

import java.net.URL;
import java.util.Collection;

import static org.onosproject.net.pi.model.PiPipeconf.ExtensionType.BMV2_JSON;
import static org.onosproject.net.pi.model.PiPipeconf.ExtensionType.P4_INFO_TEXT;

/**
 * Component that produces and registers the basic pipeconfs when loaded.
 */
@Component(immediate = true)
public final class PipeconfLoader {

    private static final String APP_NAME = "org.TelemetryBraine.app.pipeline";

    private static final PiPipeconfId INT_PIPECONF_ID = new PiPipeconfId("org.TelemetryBraine.app.pipeline");
    private static final String INT_JSON_PATH = "/p4c-out/bmv2/int.json";
    private static final String INT_P4INFO = "/p4c-out/bmv2/int_p4info.txt";

    public static final PiPipeconf INT_PIPECONF = buildIntPipeconf();

    private static final Collection<PiPipeconf> ALL_PIPECONFS = ImmutableList.of(INT_PIPECONF);

    @Reference(cardinality = ReferenceCardinality.MANDATORY)
    private PiPipeconfService piPipeconfService;

    @Reference(cardinality = ReferenceCardinality.MANDATORY)
    private CoreService coreService;

    @Activate
    public void activate() {
        coreService.registerApplication(APP_NAME);
        // Registers all pipeconf at component activation.
        ALL_PIPECONFS.forEach(piPipeconfService::register);
    }

    @Deactivate
    public void deactivate() {
        ALL_PIPECONFS.stream().map(PiPipeconf::id).forEach(piPipeconfService::unregister);
    }

    private static PiPipeconf buildIntPipeconf() {
        final URL jsonUrl = PipeconfLoader.class.getResource(INT_JSON_PATH);
        final URL p4InfoUrl = PipeconfLoader.class.getResource(INT_P4INFO);

        // INT behavior is controlled using pipeline-specific flow rule,
        // not using flow objectives, so we just borrow pipeliner to basic pipeconf.
        return DefaultPiPipeconf.builder()
                .withId(INT_PIPECONF_ID)
                .withPipelineModel(parseP4Info(p4InfoUrl))
                .addBehaviour(PiPipelineInterpreter.class, BasicInterpreterImpl.class)
                .addBehaviour(Pipeliner.class, BasicPipelinerImpl.class)
                .addBehaviour(PortStatisticsDiscovery.class, PortStatisticsDiscoveryImpl.class)
                .addBehaviour(postProgrammable.class, postProgrammableImpl.class)
                .addExtension(P4_INFO_TEXT, p4InfoUrl)
                .addExtension(BMV2_JSON, jsonUrl)
                .build();
    }

    private static PiPipelineModel parseP4Info(URL p4InfoUrl) {
        try {
            return P4InfoParser.parse(p4InfoUrl);
        } catch (P4InfoParserException e) {
            throw new IllegalStateException(e);
        }
    }
}
