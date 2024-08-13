
function AccountForm(slot) {
	return {
		formData: {
			slot: slot,
			address: "",
			account: null,
			error: null,
		},
		submitText: "Load",
		formLoading: false,
		async submitForm() {
			try {
				this.formLoading = true;
				this.submitText = "Loading";

				const getAccountUrl = `/block/${this.formData.slot}/account/${this.formData.address}`;
				const account = await fetch(getAccountUrl, {
					method: "GET",
					headers: {
						Accept: "application/json",
					},
				}).then((response) => {
					return response.json();
				});

				const getContractUrl = `/block/${this.formData.slot}/contract/${this.formData.address}`;
				const contract = await fetch(getContractUrl, {
					method: "GET",
					headers: {
						Accept: "application/json",
					},
				}).then((response) => {
					return response.json();
				});

				let storageValue;
				if (this.formData.storageKey) {
					const getStorageKeyUrl = `/block/${this.formData.slot}/contract/${this.formData.address}/storage/`;
					const storage = await fetch(getStorageKeyUrl, {
						method: "POST",
						headers: {
							"Content-Type": "application/json",
							Accept: "application/json",
						},
						body: JSON.stringify({address: this.formData.address,keys:[this.formData.storageKey]}),
					}).then((response) => {
						return response.json();
					});
					storageValue = storage[this.formData.storageKey];
				}

				console.log(storageValue);

				this.formData.account = account;
				this.formData.bytecode = contract;
				this.formData.storageValue = storageValue;
			} catch (ex) {
				this.formData.error = ex;
			} finally {
				this.formLoading = false;
				this.submitText = "Load";
			}
		},
	};
}
