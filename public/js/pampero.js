
function AccountForm(slot) {
	return {
		formData: {
			slot: slot,
			address: "",
			account: null,
		},
		submitForm() {
			actionUrl = `/block/${this.formData.slot}/account/${this.formData.address}`;
			fetch(actionUrl, {
				method: "GET",
				headers: {
					"Content-Type": "application/json",
					Accept: "application/json",
				},
			}).then((response) => {
				return response.json();
			}).then((account) => {
				this.formData.account = account;
			}).catch(error => {
				console.log("Error: ");
				console.log(error);
			});
		},
	};
}
