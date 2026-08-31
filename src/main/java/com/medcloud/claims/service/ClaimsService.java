package com.medcloud.claims.service;

import com.medcloud.claims.model.Claim;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class ClaimsService {

    private final Map<String, Claim> claims = new ConcurrentHashMap<>();

    public Map<String, String> receiveClaim(Claim claim) {

        claims.put(claim.getClaimId(), claim);

        return Map.of(
                "claimId", claim.getClaimId(),
                "status", "RECEIVED"
        );
    }

    public Claim getClaim(String claimId) {
        return claims.get(claimId);
    }

    public Collection<Claim> getAllClaims() {
        return claims.values();
    }
}
