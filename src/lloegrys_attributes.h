/**
 * Lloegrys Roguelike - Attribute System
 * Copyright (C) 2024 Lloegrys Team
 *
 * Provides type-safe attribute accessors that wrap storage IDs 40000-40006
 * for backward compatibility with existing Lua scripts.
 */

#ifndef LLOEGRYS_ATTRIBUTES_H
#define LLOEGRYS_ATTRIBUTES_H

#include <cstdint>
#include <string>

// Attribute enum - maps directly to storage IDs 40000-40006
enum class LloegrysAttribute : uint8_t {
	STRENGTH = 0,      // Storage 40000
	DEXTERITY = 1,     // Storage 40001
	INTELLIGENCE = 2,  // Storage 40002
	LUCK = 3,          // Storage 40003
	CONSTITUTION = 4,  // Storage 40004
	SPIRIT = 5,        // Storage 40005
	WISDOM = 6         // Storage 40006
};

// Base storage ID for attributes (40000)
constexpr uint32_t LLOEGRYS_ATTRIBUTE_STORAGE_BASE = 40000;

// Number of attributes
constexpr uint8_t LLOEGRYS_ATTRIBUTE_COUNT = 7;

// Attribute requirements struct for validation
struct AttributeRequirements {
	int32_t strength = 0;
	int32_t dexterity = 0;
	int32_t intelligence = 0;
	int32_t luck = 0;
	int32_t constitution = 0;
	int32_t spirit = 0;
	int32_t wisdom = 0;

	bool isEmpty() const {
		return strength == 0 && dexterity == 0 && intelligence == 0 &&
		       luck == 0 && constitution == 0 && spirit == 0 && wisdom == 0;
	}
};

// Helper function to get attribute name
inline const char* getLloegrysAttributeName(LloegrysAttribute attr) {
	switch (attr) {
		case LloegrysAttribute::STRENGTH: return "Strength";
		case LloegrysAttribute::DEXTERITY: return "Dexterity";
		case LloegrysAttribute::INTELLIGENCE: return "Intelligence";
		case LloegrysAttribute::LUCK: return "Luck";
		case LloegrysAttribute::CONSTITUTION: return "Constitution";
		case LloegrysAttribute::SPIRIT: return "Spirit";
		case LloegrysAttribute::WISDOM: return "Wisdom";
		default: return "Unknown";
	}
}

#endif // LLOEGRYS_ATTRIBUTES_H
