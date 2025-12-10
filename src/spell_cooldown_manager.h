/**
 * Lloegrys Roguelike - Spell Cooldown Manager
 * Copyright (C) 2024 Lloegrys Team
 *
 * In-memory spell cooldown system that replaces storage IDs 80000-80058.
 * Cooldowns reset on server restart (acceptable for spell cooldowns).
 */

#ifndef SPELL_COOLDOWN_MANAGER_H
#define SPELL_COOLDOWN_MANAGER_H

#include <unordered_map>
#include <cstdint>
#include <mutex>

class Player;

class SpellCooldownManager {
public:
	static SpellCooldownManager& getInstance() {
		static SpellCooldownManager instance;
		return instance;
	}

	// Check if spell is on cooldown
	bool isOnCooldown(uint32_t playerId, uint32_t spellId) const;

	// Set spell cooldown (duration in milliseconds)
	void setCooldown(uint32_t playerId, uint32_t spellId, int64_t durationMs);

	// Get remaining cooldown in milliseconds (0 if not on cooldown)
	int64_t getRemainingCooldown(uint32_t playerId, uint32_t spellId) const;

	// Clear all cooldowns for a player (call on logout)
	void clearPlayerCooldowns(uint32_t playerId);

	// Get cooldown with Constitution modifier applied (8% reduction per point)
	int64_t getModifiedCooldown(const Player* player, int64_t baseCooldown) const;

private:
	SpellCooldownManager() = default;
	~SpellCooldownManager() = default;

	// Non-copyable
	SpellCooldownManager(const SpellCooldownManager&) = delete;
	SpellCooldownManager& operator=(const SpellCooldownManager&) = delete;

	struct CooldownEntry {
		int64_t expiryTimestamp;  // OTSYS_TIME() when cooldown expires
	};

	// playerId -> spellId -> cooldown data
	std::unordered_map<uint32_t, std::unordered_map<uint32_t, CooldownEntry>> cooldowns;
	mutable std::mutex mutex;
};

#endif // SPELL_COOLDOWN_MANAGER_H
