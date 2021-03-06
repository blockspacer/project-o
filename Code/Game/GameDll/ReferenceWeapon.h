// Reference weapon for lighting tests
// John Newfield

#include "Weapon.h"
#pragma once

class CReferenceWeapon :
	public CWeapon
{
public:
	CReferenceWeapon(void);
	~CReferenceWeapon(void);
	virtual void OnAction(EntityId actorId, const ActionId& actionId, int activationMode, float value);
	virtual void GetMemoryUsage(ICrySizer * s) const { s->Add(*this); CWeapon::GetMemoryUsage(s); }
};
