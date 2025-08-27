package com.newapp.my_movies;

import androidx.test.platform.app.InstrumentationRegistry;
import org.junit.Test;
import pl.leancode.patrol.PatrolJUnitRunner;

public class MainActivityTest {

    @Test
    public void runAllDartTests() {
        PatrolJUnitRunner instrumentation = (PatrolJUnitRunner) InstrumentationRegistry.getInstrumentation();

        // Launch your app's actual MainActivity
        instrumentation.setUp(MainActivity.class);
        instrumentation.waitForPatrolAppService();

        // Run all Dart tests
        Object[] dartTests = instrumentation.listDartTests();
        for (Object testNameObj : dartTests) {
            String testName = (String) testNameObj;
            instrumentation.runDartTest(testName);
        }
    }
}
