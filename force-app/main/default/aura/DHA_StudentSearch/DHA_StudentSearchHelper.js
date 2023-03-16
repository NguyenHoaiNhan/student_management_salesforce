({
    fetchClasses: function (cmp) {
        const action = cmp.get("c.getClasses");
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state == "SUCCESS") {
                const data = response.getReturnValue();
                const result = [];

                data.forEach((val) => {
                    result.push({
                        'label': val.Name,
                        'value': val.Name,
                    });
                });

                cmp.set("v.class_opts", result);
            }
        });
        $A.enqueueAction(action);
    },
    getStudentsWithConditions: function (cmp) {
        const action = cmp.get('c.getStudentsWithConditions');
        action.setParams({
            searchVal: cmp.get('v.search_val'),
            birthDate: cmp.get('v.choosed_birthdate'),
            className: cmp.get('v.choosed_class_opt'),
        });
        cmp.set("v.spinner", true);
        action.setCallback(this, function (response) {
            const state = response.getState();
            const actions = [
                { label: 'Show details', name: 'show_details' },
            ];
            if (state == "SUCCESS") {
                cmp.set("v.column_names", [
                    { label: 'Student Code', fieldName: 'Student_Code__c', type: 'text' },
                    {
                        label: 'Student Name', fieldName: 'Id', type: 'url',
                        typeAttributes: {
                            label: { fieldName: 'Name' },
                            target: '_blank',
                            tooltip: 'Click to visit website',
                        }
                    },
                    { label: 'Birthdate', fieldName: 'Birthdate__c', type: 'text' },
                    { label: 'Address', fieldName: 'Address__c', type: 'text' },
                    { label: 'Email', fieldName: 'Email__c', type: 'email' },
                    { type: 'action', typeAttributes: { rowActions: actions } }
                ]);
                let dataTable = [];
                response.getReturnValue().forEach((val, i) => {
                    let temp = {
                        Id: '/' + val.DHA_Student__r.Id,
                        Student_Code__c: val.DHA_Student__r.Student_Code__c,
                        Name: val.DHA_Student__r.Name,
                        Birthdate__c: val.DHA_Student__r.Birthdate__c,
                        Address__c: val.DHA_Student__r.Address__c,
                        Email__c: val.DHA_Student__r.Email__c,
                    };
                    dataTable.push(temp);
                });
                cmp.set("v.table_data", dataTable);
                cmp.set("v.spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    getStudyResult: function (cmp, studentCode) {
        const action = cmp.get('c.getAssignmentsByStudentCode');
        action.setParams({
            studentCode: studentCode,
        });
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state == "SUCCESS") {
                cmp.set("v.studyResultInformation", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getNumberOfAssignedClassByStudentId: function (cmp, studentId) {
        const action = cmp.get('c.getNumberOfAssignedClassByStudentId');
        action.setParams({
            id: studentId,
        });
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state == "SUCCESS") {
                cmp.set("v.numberOfAssignedClass", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getAvarageOfFinalResults: function (cmp, studentId) {
        const action = cmp.get('c.getAvarageOfFinalResults');
        action.setParams({
            id: studentId,
        });
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state == "SUCCESS") {
                cmp.set("v.avgOfFinalScores", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getNumberOfFinalScores: function (cmp, studentId) {
        const action = cmp.get('c.getNumberOfFinalScores');
        action.setParams({
            id: studentId,
        });
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state == "SUCCESS") {
                cmp.set("v.numberOfFinalScores", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    validateForm: function (cmp) {
        const valToSearch = cmp.get('v.search_val');
        const birthdateToSearch = cmp.get('v.choosed_birthdate');
        const classToFilter = cmp.get('v.choosed_class_opt');

        if (!valToSearch && !birthdateToSearch && !classToFilter) {
            const toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type": "error",
                "message": "Please provide at least 1 condition to search for students.",
                "duration": 5000,
            });
            toastEvent.fire();
            return false;
        }

        return true;
    },
    resetForm: function (cmp) {
        cmp.set('v.search_val', null);
        cmp.set('v.choosed_birthdate', null);
        cmp.set('v.choosed_class_opt', null);
    }
});