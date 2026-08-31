package com.medcloud.claims.controller;

import com.medcloud.claims.model.Claim;
import com.medcloud.claims.service.ClaimsService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/claims")
public class ClaimsController {

    private final ClaimsService claimsService;

    public ClaimsController(ClaimsService claimsService) {
        this.claimsService = claimsService;
    }

    @PostMapping
    public ResponseEntity<Map<String, String>> receiveClaim(
            @Valid @RequestBody Claim claim) {

        return ResponseEntity.ok(
                claimsService.receiveClaim(claim)
        );
    }
@GetMapping("/{claimId}")
public ResponseEntity<Claim> getClaim(
        @PathVariable String claimId) {

    Claim claim = claimsService.getClaim(claimId);

    if (claim == null) {
        return ResponseEntity.notFound().build();
    }

    return ResponseEntity.ok(claim);
}

@GetMapping
public ResponseEntity<?> getAllClaims() {
    return ResponseEntity.ok(
            claimsService.getAllClaims()
    );
}
}
