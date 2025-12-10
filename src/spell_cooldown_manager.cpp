/**
 * Lloegrys Roguelike - Spell Cooldown Manager Implementation
 * Copyright (C) 2024 Lloegrys Team
 */

#include "spell_cooldown_manager.h"
#include "player.h"
#include "tools.h"  // For OTSYS_TIME()

bool SpellCooldownManager::isOnCooldown(uint32_t playerId, uint32_t spellId) const
{
	std::lock_guard<std::mutex> lock(mutex);

	auto playerIt = cooldowns.find(playerId);
	if (playerIt == cooldowns.end()) {
		return false;
	}

	auto spellIt = playerIt->second.find(spellId);
	if (spellIt == playerIt->second.end()) {
		return false;
	}

	return OTSYS_TIME() < spellIt->second.expiryTimestamp;
}

void SpellCooldownManager::setCooldown(uint32_t playerId, uint32_t spellId, int64_t durationMs)
{
	std::lock_guard<std::mutex> lock(mutex);

	CooldownEntry entry;
	entry.expiryTimestamp = OTSYS_TIME() + durationMs;
	cooldowns[playerId][spellId] = entry;
}

int64_t SpellCooldownManager::getRemainingCooldown(uint32_t playerId, uint32_t spellId) const
{
	std::lock_guard<std::mutex> lock(mutex);

	auto playerIt = cooldowns.find(playerId);
	if (playerIt == cooldowns.end()) {
		return 0;
	}

	auto spellIt = playerIt->second.find(spellId);
	if (spellIt == playerIt->second.end()) {
		return 0;
	}

	int64_t remaining = spellIt->second.expiryTimestamp - OTSYS_TIME();
	return remaining > 0 ? remaining : 0;
}

void SpellCooldownManager::clearPlayerCooldowns(uint32_t playerId)
{
	std::lock_guard<std::mutex> lock(mutex);
	cooldowns.erase(playerId);
}

int64_t SpellCooldownManager::getModifiedCooldown(const Player* player, int64_t baseCooldown) const
{
	if (!player) {
		return baseCooldown;
	}

	// Constitution reduces cooldown by 8% per point
	float reduction = player->getCooldownReduction();
	int64_t modified = static_cast<int64_t>(baseCooldown * (1.0f - reduction));

	// Minimum cooldown is 10% of base
	int64_t minimum = baseCooldown / 10;
	return modified > minimum ? modified : minimum;
}
