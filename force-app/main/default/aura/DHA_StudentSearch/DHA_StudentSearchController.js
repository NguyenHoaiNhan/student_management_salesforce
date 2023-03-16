({
    init: function (cmp, event, helper) {
        helper.fetchClasses(cmp);
        helper.getStudentsWithConditions(cmp);
    },
    onSearch: function (cmp, event, helper) {
        if (helper.validateForm(cmp)) {
            helper.getStudentsWithConditions(cmp);
        };
    },
    onClear: function (cmp, event, helper) {
        helper.resetForm(cmp);
        helper.getStudentsWithConditions(cmp);
    },
    openModel: function (cmp, event, helper) {
        const row = event.getParam('row');
        const studentId = row.Id.replace(row.Id[0], '');
        cmp.set("v.clickedStudentId", studentId);
        helper.getStudyResult(cmp, row.Student_Code__c);
        helper.getNumberOfAssignedClassByStudentId(cmp, studentId);
        helper.getAvarageOfFinalResults(cmp, studentId);
        helper.getNumberOfFinalScores(cmp, studentId);
        cmp.set("v.isModalOpen", true);
    },
    closeModal: function (cmp, event, helper) {
        cmp.set("v.isModalOpen", false);
    },
    handleSectionToggle: function (cmp, event) {
        const openSections = event.getParam('openSections');
    },
})