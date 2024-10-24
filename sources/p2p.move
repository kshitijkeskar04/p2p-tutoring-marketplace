module P2PTutoring::Marketplace {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a tutoring session with escrow.
    struct Session has store, key {
        student: address,       // Student's address
        tutor: address,         // Tutor's address
        amount: u64,            // Amount to be paid for the session
        is_completed: bool,     // Whether the session has been marked as complete
    }

    /// Function to book a tutoring session.
    public fun book_session(student: &signer, tutor: address, amount: u64) acquires Session {
        let student_addr = signer::address_of(student);
module P2PTutoring::Marketplace {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a tutoring session with escrow.
    struct Session has store, key {
        student: address,       // Student's address
        tutor: address,         // Tutor's address
        amount: u64,            // Amount to be paid for the session
        is_completed: bool,     // Whether the session has been marked as complete
    }

    /// Function to book a tutoring session.
    public fun book_session(student: &signer, tutor: address, amount: u64) acquires Session {
        let student_addr = signer::address_of(student);

        let session = Session {
            student: student_addr,
            tutor,
            amount,
            is_completed: false,
        };
        move_to(student, session);

        // Transfer funds from student to tutor directly (escrow mechanism)
        let payment = coin::withdraw<AptosCoin>(student, amount);
        coin::deposit<AptosCoin>(tutor, payment); // Deposit funds to tutor immediately
    }

    /// Function to mark the session as complete.
    public fun complete_session(tutor: &signer, student: address) acquires Session {
        // Ensure that the session resource exists at the student's address
        let session = borrow_global_mut<Session>(student);

        // Ensure the tutor is correct and the session is not yet completed
        assert!(session.tutor == signer::address_of(tutor), 100);
        assert!(!session.is_completed, 101);

        // Mark session as complete (funds already transferred in `book_session`)
        session.is_completed = true;
    }
}

        let session = Session {
            student: student_addr,
            tutor,
            amount,
            is_completed: false,
        };
        move_to(student, session);

        // Transfer funds from student to tutor directly (escrow mechanism)
        let payment = coin::withdraw<AptosCoin>(student, amount);
        coin::deposit<AptosCoin>(tutor, payment); // Deposit funds to tutor immediately
    }

    /// Function to mark the session as complete.
    public fun complete_session(tutor: &signer, student: address) acquires Session {
        let session = borrow_global_mut<Session>(student);

        // Ensure the tutor is correct and the session is not yet completed
        assert!(session.tutor == signer::address_of(tutor), 100);
        assert!(!session.is_completed, 101);

        // Mark session as complete (funds already transferred in `book_session`)
        session.is_completed = true;
    }
}
