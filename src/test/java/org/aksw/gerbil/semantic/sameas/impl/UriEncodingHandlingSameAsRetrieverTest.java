package org.aksw.gerbil.semantic.sameas.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

@RunWith(Parameterized.class)
public class UriEncodingHandlingSameAsRetrieverTest {

    @Parameters
    public static Collection<Object[]> data() {
        List<Object[]> testConfigs = new ArrayList<Object[]>();
        testConfigs.add(new Object[] { null, null });
        testConfigs.add(new Object[] { "http://dbpedia.org/resource/Berlin", null });
        testConfigs.add(new Object[] { "http://dbpedia.org/resource/Gainesville,_Florida",
                "http://dbpedia.org/resource/Gainesville%2C_Florida" });
        testConfigs.add(new Object[] { "http://dbpedia.org/resource/Gainesville%2C_Florida",
                "http://dbpedia.org/resource/Gainesville,_Florida" });
        testConfigs.add(new Object[] { "http://dbpedia.org/resource/Richard_Taylor_(British_politician)",
                "http://dbpedia.org/resource/Richard_Taylor_%28British_politician%29" });
        testConfigs.add(new Object[] { "http://dbpedia.org/resource/Richard_Taylor_%28British_politician%29",
                "http://dbpedia.org/resource/Richard_Taylor_(British_politician)" });
        return testConfigs;
    }

    private String uri;
    private String expectedUri;

    public UriEncodingHandlingSameAsRetrieverTest(String uri, String expectedUri) {
        this.uri = uri;
        this.expectedUri = expectedUri;
    }

    @Test
    public void run() {
        UriEncodingHandlingSameAsRetriever retriever = new UriEncodingHandlingSameAsRetriever();
        Set<String> uris = retriever.retrieveSameURIs(uri);
        if (expectedUri == null) {
            Assert.assertNull(expectedUri);
        } else {
            Assert.assertNotNull(uris);
            Assert.assertTrue(uris.toString() + " does not contain the expected URI \"" + expectedUri + "\".",
                    uris.contains(expectedUri));
        }
    }
}