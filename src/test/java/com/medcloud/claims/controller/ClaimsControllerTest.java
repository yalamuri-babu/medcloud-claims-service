package com.medcloud.claims.controller;

import com.medcloud.claims.model.Claim;
import com.medcloud.claims.service.ClaimsService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ClaimsController.class)
class ClaimsControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private ClaimsService claimsService;

    @Test
    void shouldReceiveValidClaim() throws Exception {

        when(claimsService.receiveClaim(any(Claim.class)))
                .thenReturn(Map.of(
                        "claimId", "CLM-10001",
                        "status", "RECEIVED"
                ));

        String request = """
                {
                  "claimId": "CLM-10001",
                  "memberId": "MEM-10001",
                  "providerId": "PRV-50001",
                  "totalAmount": 250.00
                }
                """;

        mockMvc.perform(
                post("/api/v1/claims")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(request)
        )
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.claimId").value("CLM-10001"))
    .andExpect(jsonPath("$.status").value("FAILED_ON_PURPOSE"));}
}
