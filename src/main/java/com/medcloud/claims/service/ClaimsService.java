package com.medcloud.claims.service;

import com.medcloud.claims.model.Claim;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class ClaimsService {

    public Map<String, String> receiveClaim(Claim claim) {
        return Map.of(
                "claimId", claim.getClaimId(),
                "status", "RECEIVED"
        );
    }
}
