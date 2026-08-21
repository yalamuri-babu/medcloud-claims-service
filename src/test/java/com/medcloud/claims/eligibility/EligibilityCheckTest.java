package com.medcloud.claims.eligibility;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class EligibilityCheckTest {

    @Test
    void shouldConfirmMemberIsEligible() {

        String actualStatus = "INELIGIBLE";

        assertEquals("ELIGIBLE", actualStatus);
    }
}
