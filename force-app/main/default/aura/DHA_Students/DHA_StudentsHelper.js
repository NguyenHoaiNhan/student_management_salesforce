({
	getDuplicateRecords: function (cmp) {
		const name = cmp.get('v.nameToSearch');
		const birthDate = cmp.get('v.birthdateToSearch');
		const address = cmp.get('v.addressToSearch');
		const gender = cmp.get('v.genderToSearch');
		const email = cmp.get('v.emailToSearch');

		const action = cmp.get('c.findDuplicatedRecords');
		action.setParams({
			name: name,
			birthdate: birthDate,
			address: address,
			gender: gender,
			email: email,
		});

		action.setCallback(this, (response) => {
			const state = response.getState();
			if (state == "SUCCESS") {
				let data = [];
				response.getReturnValue().forEach((val) => {
					let temp = val;
					temp.CreatedDate = val.CreatedDate.toString().substring(0, 10);
					data.push(temp);
				});
				cmp.set('v.numberOfDup', 'We found ' + data.length + ' possible duplicate record(s)');
				cmp.set('v.tableData', data);
			}
		});
		$A.enqueueAction(action);
	},
	validForm: function (cmp) {
		const allValid = cmp.find('form-input').reduce(function (validSoFar, inputCmp) {
			inputCmp.reportValidity();
			return validSoFar && inputCmp.checkValidity();
		}, true);
		return allValid;
	},
})