
function AccountForm(slot) {
	return {
		formData: {
			slot: slot,
			address: "",
			account: null,
			error: null,
		},
		submitForm() {
			actionUrl = `/block/${this.formData.slot}/account/${this.formData.address}`;
			fetch(actionUrl, {
				method: "GET",
				headers: {
					Accept: "application/json",
				},
			}).then((response) => {
				return response.json();
			}).then((account) => {
				this.formData.account = account;
			}).catch((error) => {
				this.formData.error = error;
			});
		},
	};
}
